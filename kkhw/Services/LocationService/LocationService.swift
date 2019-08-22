//
//  LocationService.swift
//  kkhw
//
//  Created by wonwoo on 2019/08/10.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCoreLocation

protocol LocationServiceApi{
}

class LocationService:LocationServiceApi{
    private init(){
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    static let shared = LocationService()
    private let locationManager:CLLocationManager
    lazy var curlocationObservable:Observable<CLLocation?> = {
        return locationManager.rx.location.take(1)
    }()
    
    lazy var authorizationObservable:Observable<CLAuthorizationEvent> = {
        return locationManager.rx.didChangeAuthorization.asObservable()
    }()
    
    private let bag = DisposeBag()
}
