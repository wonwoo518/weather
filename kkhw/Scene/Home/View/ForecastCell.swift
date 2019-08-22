//
//  ForecastCell.swift
//  kkhw
//
//  Created by wonwoo on 19/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import UIKit
protocol ForecastCellProtocol{
    func reloadData(forecastWeather:List)
}
class ForecastCell: UICollectionViewCell, ForecastCellProtocol {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    var model:List?{
        didSet{
            dayLabel.text = model?.dtTxt ?? ""
            descLabel.text = model?.weather?[0].weatherDescription ?? ""
            maxTemp.text = "\(model?.main?.tempMax ?? 0)"
            minTemp.text = "\(model?.main?.tempMin ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadData(forecastWeather:List){
        self.model = forecastWeather
    }
}
