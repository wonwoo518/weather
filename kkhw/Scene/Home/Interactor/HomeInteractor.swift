//
//  HomeInteractor.swift
//  kkhw
//
//  Created by wonwoo on 22/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation

protocol HomeInteractorProtocol {
    func addNewWeather(location:LocationModel)->LocationsModel
    func fetchWeather(locations:LocationsModel)
}

class HomeInteractor:HomeInteractorProtocol{
    func addNewWeather(location:LocationModel)->LocationsModel{
        return WeatherPublishService.shard.addWeather(locationModel: location)
    }
    
    func fetchWeather(locations:LocationsModel){
        WeatherPublishService.shard.locations = locations
    }
}
