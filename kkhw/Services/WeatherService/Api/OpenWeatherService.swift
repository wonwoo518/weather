//
//  WeatherRequster.swift
//  kkhw
//
//  Created by wonwoo on 09/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherServiceSupplier {
    var appKey:String {get}
    var baseUrl:URL {get}
}

protocol WeatherServiceApi {
    func currentWeather(param:Dictionary<String,String>)->Single<CurrentWeather>
    func weatherForecast(param:Dictionary<String,String>)->Single<ForecastWeather>
}

class OpenWeatherService{
    private init(){}
    static let shared:OpenWeatherService = OpenWeatherService()
    let requester:ServiceRequester = ServiceRequester()
    
    fileprivate func param2String(_ param:Dictionary<String,String>)->String{
        let newParam = [param, ["APPID":appKey],["units":"metric"]].flatMap{return $0}
        
        var paramString = newParam.reduce("") { (ret, tup) -> String in
            return "\(ret)&\(tup.key)=\(tup.value)"
        }
        
        paramString.removeFirst()
        return paramString
    }
}

extension OpenWeatherService : WeatherServiceSupplier{
    var appKey:String{
        return "29887dba0637ba9e7d73bd3e3b41b14a"
    }
    var baseUrl: URL {
        return URL(string: "http://api.openweathermap.org/data/2.5/")!
    }
}

extension OpenWeatherService : WeatherServiceApi{
    func currentWeather(param: Dictionary<String, String>) -> Single<CurrentWeather> {
        return requester.request(baseUrl: baseUrl, path: "weather?\(param2String(param))")
    }
    
    func weatherForecast(param: Dictionary<String, String>) -> Single<ForecastWeather> {
        return requester.request(baseUrl: baseUrl, path: "forecast?\(param2String(param))")
    }
}
