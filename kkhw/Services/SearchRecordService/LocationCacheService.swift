//
//  LocationCacheService.swift
//  kkhw
//
//  Created by wonwoo on 14/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation

protocol LocationCacheApi {
    func write(location:Codable)
    func restoreIfNeed()->Codable
    func setCurrentLocation(location:Codable)
}

class LocationCacheService{
    static let shared:LocationCacheService = LocationCacheService()
    private var needRestore:Bool = true
    private init(){
        locations = restoreIfNeed() as? LocationsModel ?? LocationsModel()
    }
    
    fileprivate var locations:LocationsModel = LocationsModel()
    fileprivate let recordKey = "search_weather_history"
}

extension LocationCacheService:LocationCacheApi{
    
    private func _write(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(locations) {
            UserDefaults.standard.set(encoded, forKey: recordKey)
        }
    }
    
    func setCurrentLocation(location: Codable) {
        if let location = location as? LocationModel{
            locations.list.removeFirst()
            locations.list.insert(location , at: 0)
            
            _write()
            
        }
    }
    
    func write(location: Codable) {
        guard let location = location as? LocationModel else{
            return
        }
        
        needRestore = true
        locations.list.append(location)
        
        _write()
    }
    
    func restoreIfNeed()->Codable{
        if needRestore == false{
            return locations
        }
        
        if let data = UserDefaults.standard.object(forKey: recordKey) as? Data {
            let decoder = JSONDecoder()
            if let locations = try? decoder.decode(LocationsModel.self, from: data){
                needRestore = false
                self.locations = locations
                return locations
            }
        }
        return LocationsModel()
    }
}
