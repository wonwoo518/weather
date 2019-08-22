//
//  WeatherInteractor.swift
//  kkhw
//
//  Created by wonwoo on 19/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherInteratorProtocol {
    func setWeatherSubscribe(location:LocationModel?)
    func refreshWeather()
}

class WeatherInteractor:WeatherInteratorProtocol{
    
    var presenter:WeatherPresenterProtocol?
    
    private var location:LocationModel?
    private var bag = DisposeBag()
    
    //현재 날씨, 예보 날씨 observable을 구독하기 시작
    func setWeatherSubscribe(location:LocationModel?){

        self.location = location
        
        self.bag = DisposeBag()

        WeatherPublishService.shard.currentWeathersVariable
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( { (item) in
                
                if let weathers =  item.event.element, let id = self.location?.id{
                    self.responseResult(locationId:id, weather: weathers[id], forecastWeather: nil)
                }
                
            }).disposed(by: bag)
        
        WeatherPublishService.shard.forecastWeathersVariable
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe( { (item) in
                
                if let forecasts =  item.event.element, let id = self.location?.id, let forecast = forecasts[id]{
                    self.responseResult(locationId:id, weather: nil, forecastWeather: forecast)
                }
                
            }).disposed(by: bag)
        
    }

    //현재 날씨와 예보를 새로 요청
    func refreshWeather() {
        if let location = location {
            WeatherPublishService.shard.updateWeather(locationModel: location)
        }
    }
    
    //현재 날씨와 예보 요청에 대한 응답처리
    private func responseResult(locationId:String?, weather:CurrentWeather?, forecastWeather:ForecastWeather?){
        var location:LocationModel?
        if let id =  locationId{
            let list = WeatherPublishService.shard.locations?.list.filter({ (model) -> Bool in
                return model.id == id
            })
            if list?.count ?? 0 > 0{
                location = list![0]
            }
        }
        if let weather = weather{
            presenter?.presentWeather(weatherModel: weather, location:location)
        }
        if let forecastWeather = forecastWeather{
            presenter?.presentForecast(forecastModel: forecastWeather, location: location)
        }
    }
}
