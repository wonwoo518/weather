//
//  WeatherCell.swift
//  kkhw
//
//  Created by wonwoo on 2019/08/11.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import MapKit

//CollectionViewController에서 WeatherCell data load
protocol WeatherCellProtocol{
    func reloadData(data: LocationModel?)
}

//VIP에서 P->V로 이벤트 처리위한 프로토콜
protocol WeatherDisplayProtocol : class{
    func displayWeather(viewModel:WeatherCellViewModel)
    func displayForecast(viewModel:WeatherCellViewModel)
}

struct WeatherCellModel{
    var location:LocationModel?
    var weatherModel:CurrentWeather?
    var forecastWeatherModel:[List]?
}
struct WeatherCellViewModel{
    init(model:WeatherCellModel) {
        self.model = model
        
        if let weatherModel = model.weatherModel{
            temp = "\(weatherModel.main?.temp ?? 0)"
            desc = "\(weatherModel.weather?[0].weatherDescription ?? "")"
            humidity = "습도 \(weatherModel.main?.humidity ?? 0)"
            wind = "바람 deg:\(weatherModel.wind?.deg ?? 0), speed:\(model.weatherModel?.wind?.speed ?? 0)"
            cloud = "구름 \(weatherModel.clouds?.all ?? 0)"
        }
        if let locationModel = model.location{
            cityName = "\(locationModel.name ?? "")"
        }
        
        if let forecastModel = model.forecastWeatherModel{
            forecastList = forecastModel
        }
    }

    var model:WeatherCellModel

    var temp:String?
    var desc:String?
    var cityName:String?
    var humidity:String?
    var wind:String?
    var cloud:String?
    var forecastList:[List]?
}


class WeatherCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var windDescLabel: UILabel!
    @IBOutlet weak var cloudDescLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    
    var viewModel:WeatherCellViewModel = WeatherCellViewModel(model: WeatherCellModel(location: nil, weatherModel: nil, forecastWeatherModel: nil))
    
    var refreshControl: UIRefreshControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupVIP()
        setupSubviews()
    }
    
    var interactor:WeatherInteratorProtocol?
    func setupVIP(){
        
        let view = self
        let interator = WeatherInteractor()
        let presenter = WeatherPresenter()
        
        view.interactor = interator
        interator.presenter = presenter
        presenter.viewController = view
    }
    
    func setupSubviews(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "날씨 업데이트")
        refreshControl.addTarget(self, action: #selector(updateWeather), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        forecastCollectionView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ForecastCell.self))
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
    }
    
    @objc func updateWeather(){
        interactor?.refreshWeather()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        guard let  vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchPlaceViewController") as? SearchPlaceViewController else{
            return
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)

    }
}

extension WeatherCell:WeatherCellProtocol{
    func reloadData(data: LocationModel?) {
        self.interactor?.setWeatherSubscribe(location: data)
    }
}


extension WeatherCell:WeatherDisplayProtocol{
    func displayWeather(viewModel: WeatherCellViewModel) {
        self.refreshControl.endRefreshing()
        self.viewModel = WeatherCellViewModel(model: WeatherCellModel(location: viewModel.model.location, weatherModel: viewModel.model.weatherModel, forecastWeatherModel: self.viewModel.forecastList))
        
        if let _ = self.viewModel.model.location , let _ = self.viewModel.model.weatherModel{
            self.tempLabel.text = viewModel.temp
            self.cityNameLabel.text = viewModel.cityName
            self.weatherDescLabel.text = viewModel.desc
            self.humidityLabel.text = viewModel.humidity
            self.windDescLabel.text = viewModel.wind
            self.cloudDescLabel.text = viewModel.cloud
        }
    }

    func displayForecast(viewModel: WeatherCellViewModel) {
        self.refreshControl.endRefreshing()
        self.viewModel = WeatherCellViewModel(model: WeatherCellModel(location: self.viewModel.model.location, weatherModel: self.viewModel.model.weatherModel, forecastWeatherModel: viewModel.model.forecastWeatherModel))
        forecastCollectionView.reloadData()
    }
    
    
}

extension WeatherCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension WeatherCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastCell.self), for: indexPath) as? ForecastCell else{
            return ForecastCell(frame:.zero)
        }
        if let data = viewModel.forecastList?[indexPath.row]{
            cell.reloadData(forecastWeather: data)
        }

        return cell
    }
}
