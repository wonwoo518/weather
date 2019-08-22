//
//  WeatherModel.swift
//  kkhw
//
//  Created by wonwoo on 09/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

//Forecast Weather Model
struct ForecastWeather: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List]?
    let city: City?
}


//Sub-Models
struct Clouds: Codable {
    let all: Int?
}

struct Coord: Codable {
    let lon, lat: Double?
}

struct Main: Codable {
    let temp, tempMin, tempMax, pressure: Double?
    let seaLevel, grndLevel: Double?
    let humidity: Int?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}


struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}


struct Wind: Codable {
    let speed: Double?
    let deg: Double?
}


struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let timezone: Int?
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List]?
}

struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let rain: Rain?
    let snow: Snow?
    let sys: Sys?
    let dtTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, rain, snow, sys
        case dtTxt = "dt_txt"
    }
}

struct Rain: Codable {
    let the3H : Double?
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Snow: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}



