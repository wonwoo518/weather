//
//  ViewController.swift
//  kkhw
//
//  Created by wonwoo on 09/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import UIKit
import RxSwift
import MapKit

class HomeViewController: UIViewController {

    let bag:DisposeBag = DisposeBag()
    var locations:LocationsModel?{
        didSet{
            weatherCollectionView.reloadData()
        }
    }

    @IBOutlet weak var weatherCollectionView:UICollectionView!
    let interactor:HomeInteractor = HomeInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        locations = LocationCacheService.shared.restoreIfNeed() as? LocationsModel ?? LocationsModel()
        interactor.fetchWeather(locations: locations!)
    }
    
    func setupCollectionView(){
        
        weatherCollectionView.register(UINib(nibName: String(describing:WeatherCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing:WeatherCell.self))
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.reloadData()
    }

    func addNewWeather(location:LocationModel){
        locations = interactor.addNewWeather(location: location)
        weatherCollectionView.scrollToItem(at: IndexPath(row: (locations?.list.count ?? 1) - 1, section: 0), at: .right, animated: false)
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locations?.list.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:WeatherCell.self), for: indexPath)
        if let cell = cell as? WeatherCell{
            let model = self.locations?.list[indexPath.row]
            cell.reloadData(data: model)
        }
        return cell
    }
    
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
