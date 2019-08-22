//
//  WeatherPresenter.swift
//  kkhw
//
//  Created by wonwoo on 19/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation

protocol WeatherPresenterProtocol {
    func presentWeather(weatherModel:CurrentWeather?, location:LocationModel?)
    func presentForecast(forecastModel:ForecastWeather?, location:LocationModel?)
}

class WeatherPresenter : WeatherPresenterProtocol{
    
    weak var viewController : WeatherDisplayProtocol?
    
    func presentWeather(weatherModel:CurrentWeather?, location:LocationModel?) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWeather(viewModel: WeatherCellViewModel(model: WeatherCellModel(location: location, weatherModel: weatherModel, forecastWeatherModel: nil)))
        }
    }
    
    func presentForecast(forecastModel:ForecastWeather?, location:LocationModel?){
        self.viewController?.displayForecast(viewModel: WeatherCellViewModel(model: WeatherCellModel(location: location, weatherModel: nil, forecastWeatherModel: forecastModel?.list)))
    }
}
