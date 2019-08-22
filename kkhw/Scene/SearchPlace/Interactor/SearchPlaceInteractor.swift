//
//  SearchPlaceInteractor.swift
//  kkhw
//
//  Created by wonwoo on 14/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import MapKit
import RxSwift


protocol SearchPlaceBusinessLogic {
    func request(query:String?, complet:((_ items:[MKMapItem]?) -> Void)?)
    func addNewLocation(mapItem: MKMapItem)
}

class SearchPlaceInteractor : SearchPlaceBusinessLogic{
    
    
    let bag = DisposeBag()
    var currCoord:CLLocationCoordinate2D?
    
    func request(query: String?, complet: (([MKMapItem]?) -> Void)?) {
        if query?.count ?? 0 > 1{
            let request = { (_ coord:CLLocationCoordinate2D) -> Void in
                let req = MKLocalSearch.Request()
                req.naturalLanguageQuery = query
                req.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                
                MKLocalSearch(request: req).start(completionHandler: { (response, error) in
                    guard let response = response else{
                        complet?(nil)
                        return
                    }
                    
                    complet?(response.mapItems)
                })
            }
            
            if let currCoord = self.currCoord{
                request(currCoord)
                return
            }
            
            LocationService.shared.curlocationObservable
                .subscribe(onNext: { [weak self] in
                guard let coord = $0?.coordinate else{
                    return
                }
                self?.currCoord = coord
                request(coord)
                    
            }).disposed(by: bag)
        }
    }
    
    func addNewLocation(mapItem: MKMapItem){
        let model = LocationModel(item: mapItem)
        if let vc = UIApplication.shared.keyWindow?.rootViewController as? HomeViewController{
            vc.addNewWeather(location: model)
        }
    }
}
