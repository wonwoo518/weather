//
//  WeatherService.swift
//  kkhw
//
//  Created by 1002237 on 09/08/2019.
//  Copyright © 2019 1002237. All rights reserved.
//

import Foundation
import RxSwift
protocol WeatherServiceApi {
    func currentWeather()->Observable<CurrentWeather>
    func weatherForecast()->Observable<ForecastWeather>
}

class OpenWeatherService : WeatherServiceApi{
    func currentWeather() -> Observable<CurrentWeather> {
        return WeatherRequster.shared.request(path:"weather", param: ["id":""])
    }
    
    func weatherForecast() -> Observable<ForecastWeather> {
        return WeatherRequster.shared.request(path:"forecast", param: ["id":""])
    }
}
