//
//  SearchLocationViewController.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import UIKit

protocol SearchLocationDelegate: AnyObject {
    func locationDidChoose(location: LocationElement)
}

class SearchLocationViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SearchLocationDelegate?
    
    private var locations = Location() {
        didSet {
            updateScreenAppearance()
        }
    }
    var viewModel: SearchLocationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        observeViewModel()
    }
    
    private func observeViewModel() {
        viewModel?.render = { [weak self] locations in
            self?.locations = locations
        }
    }
    
    private func updateScreenAppearance() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - SerchBar
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.findLocation(searchText)
    }
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        print(#function)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        cell.render(with: locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.locationDidChoose(location: locations[indexPath.row])
        dismiss(animated: false)
    }
}
