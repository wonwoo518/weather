//
//  WeatherPublishService.swift
//  kkhw
//
//  Created by wonwoolee on 2019/08/17.
//  Copyright © 2019 wonwoolee. All rights reserved.
//

import Foundation
import RxSwift
import MapKit
import CoreLocation

protocol WeatherPublishServiceProtocol{
    func requestWeathers()
    func updateWeather(locationModel:LocationModel)
    func addWeather(locationModel:LocationModel)->LocationsModel
}


class WeatherPublishService:WeatherPublishServiceProtocol{
    static let shard:WeatherPublishService = WeatherPublishService()
    private init(){}
    
    var bag:DisposeBag = DisposeBag()
    typealias T1 = Dictionary<String, CurrentWeather>
    typealias T2 = Dictionary<String, ForecastWeather>
    var currentWeathersVariable:Variable<T1> = Variable<T1>([:])
    var forecastWeathersVariable:Variable<T2> = Variable<T2>([:])
    
    var locations:LocationsModel?{
        didSet{
            requestWeathers()
        }
    }
    
    private func request(_ bag:DisposeBag, _ locationModel:LocationModel){
        let param = ["lat":"\(locationModel.lat)","lon":"\(locationModel.lon)"]
        OpenWeatherService.shared.currentWeather(param: param)
        .subscribe(onSuccess: { [weak self] weather  in
            guard let `self` = self else { return }
            
            var dic = self.currentWeathersVariable.value
            dic[locationModel.id] = weather
            self.currentWeathersVariable.value = dic
        }).disposed(by: bag)
            
        
        OpenWeatherService.shared.weatherForecast(param: param)
        .subscribe(onSuccess: { [weak self] weather  in
                guard let `self` = self else { return }
                
                var dic = self.forecastWeathersVariable.value
                dic[locationModel.id] = weather
                self.forecastWeathersVariable.value = dic
                
            }).disposed(by: bag)
    }
    
    func requestWeathers(){
        guard let locations = locations else {
            return
        }
        
        bag = DisposeBag()
        locations.list.enumerated().forEach { [weak self](index, locationModel) in
            guard let `self` = self else { return }
            if locationModel.isCurrenLocation{
                
                //step1. transform latitude, longitude to location name for name display
                //step2. request weather info
                let transformCoordToName = { [weak self] (cllocation:CLLocation, callback:@escaping (_ bag:DisposeBag, _ locationModel:LocationModel)->Void )->Void in
                    guard let `self` = self else { return }
                    let gecoder = CLGeocoder()
                    gecoder.reverseGeocodeLocation(cllocation, completionHandler: { (placeMarks, err) in
                        if let place = placeMarks?.first{
                            var currentLocationModel = LocationModel(item: MKMapItem(placemark: MKPlacemark(placemark: place)))
                            currentLocationModel.isCurrenLocation = true
                            LocationCacheService.shared.setCurrentLocation(location: currentLocationModel)
                            self.locations?.list[0] = currentLocationModel
                            callback(self.bag, currentLocationModel)
                        }
                    })
                }
                
                LocationService.shared.authorizationObservable
                    .subscribe(onNext:{
                        switch($0.status){
                        case .authorizedWhenInUse:
                            guard let cllocation = $0.manager.location else { return }
                            transformCoordToName(cllocation, self.request)
                        default:()
                        }

                    }).disposed(by: bag)

                
                LocationService.shared.curlocationObservable.subscribe(onNext:{
                    let cllocation = $0 ??  CLLocation(latitude: locationModel.lat, longitude: locationModel.lon)
                    transformCoordToName(cllocation, self.request)
                    
                }).disposed(by: bag)
            }else{
                self.request(self.bag, locationModel)
            }
        }
    }
    
    func updateWeather(locationModel:LocationModel){
        request(self.bag, locationModel)
    }
    
    func addWeather(locationModel:LocationModel)->LocationsModel{
        LocationCacheService.shared.write(location: locationModel)
        locations = LocationCacheService.shared.restoreIfNeed() as? LocationsModel
        return locations!
    }
}
