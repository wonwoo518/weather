//
//  LocationModel.swift
//  kkhw
//
//  Created by wonwoo on 14/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import RxSwift
import MapKit

class LocationsModel:Codable{
    var list:[LocationModel] = []

    init() {
        let defaultLatitude:Double = 37.566
        let defaultLongitude:Double = 126.9784
        var loction = LocationModel(item: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude))))
        loction.isCurrenLocation = true
        self.list.append(loction)
    }
}

struct LocationModel:Codable, Hashable{
    
    init(item:MKMapItem) {
        name = item.name
        lat = item.placemark.coordinate.latitude
        lon = item.placemark.coordinate.longitude
    }
    
    init(name:String?, lat:Double, lon:Double) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }

    static let currentLocationId:String = "currentLocationId"
    var isCurrenLocation:Bool = false
    var name:String?
    var lat:Double
    var lon:Double
    var id:String {
        return isCurrenLocation == true ? LocationModel.currentLocationId : "\(lat),\(lon)"
    }
}
