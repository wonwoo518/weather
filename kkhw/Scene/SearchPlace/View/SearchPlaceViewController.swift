//
//  SearchPlaceViewController.swift
//  kkhw
//
//  Created by wonwoo on 13/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import UIKit
import MapKit

class SearchPlaceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var items:[MKMapItem] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var interactor:SearchPlaceInteractor = SearchPlaceInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    func setupSubview(){
        tableView.register(LocationListCell.self, forCellReuseIdentifier: String(describing: LocationListCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.lightGray
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
}

extension SearchPlaceViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationListCell.self), for: indexPath) as? LocationListCell else{
            return LocationListCell(frame: .zero)
        }
        
        cell.reload(data: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interactor.addNewLocation(mapItem: self.items[indexPath.row])
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
}
extension SearchPlaceViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        interactor.request(query: searchController.searchBar.text) { (items) in
            self.items = items ?? []
        }
    }
}

extension SearchPlaceViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

class LocationListCell: UITableViewCell{
    private let normalFontString = "Apple SD gothic neo"
    private lazy var locationLabel:UILabel = {
        let l = UILabel(frame: .zero)
        l.font = UIFont(name: normalFontString, size: 20)
        l.textColor = .black
        addSubviewWithSameSize(l)
        
        return l
    }()
    
    func reload(data:MKMapItem){
        locationLabel.text = "\(data.name ?? ""),\(data.placemark.countryCode ?? "")"
    }
}
