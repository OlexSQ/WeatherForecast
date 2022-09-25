//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Mac on 22.09.2022.
//

import UIKit
import Swinject

class MainViewController: UIViewController, SearchLocationDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var weatherPerDay = [WeatherPerDay]()
    private var weatherPerHour = [WeatherPerHour]()
    
    var viewModel: MainViewModel?
    private var props: Props = .loading {
        didSet {
            updateScreenAppearance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        viewModel?.bind()
    }
    
    private func observeViewModel() {
        viewModel?.render = { [weak self] props in
            self?.props = props
        }
    }
    
    private func updateScreenAppearance() {
        switch props {
        case .loading:
            print("loading")
        case .successCurrentWeather(data: let data):
            updateCurrentWeather(with: data)
        case .successWeatherPerHour(data: let data):
            self.weatherPerHour = data
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        case .successWeatherPerDay(data: let data):
            self.weatherPerDay = data
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        case .error(message: let message):
            print("error")
        }
    }
    
    private func updateCurrentWeather(with data: CurrentWeather) {
        DispatchQueue.main.async { [weak self] in
            self?.locationLabel.text = data.location
            self?.currentDateLabel.text = data.date
            self?.currentWeatherImageView.image = UIImage(named: data.image)
            self?.currentWeatherLabel.text = "\(data.maxTemp)/\(data.minTemp)"
            self?.currentHumidityLabel.text = data.humidity
            self?.currentWindLabel.text = data.wind
        }
    }
    
    func locationDidChoose(location: LocationElement) {
        viewModel?.showWeatherForecastFor(location)
    }
    
    // MARK: - Actions
    @IBAction func searchLocationButtonPressed(_ sender: UIButton) {
        let viewController = Container.sharedContainer.resolve(SearchLocationViewController.self)!
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        present(viewController, animated: false)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherPerDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneDayCell", for: indexPath) as! OneDayTableViewCell
        cell.render(with: weatherPerDay[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherPerHour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneHourCell", for: indexPath) as! OneHourCollectionViewCell
        cell.render(with: weatherPerHour[indexPath.row])
        return cell
    }
}

// MARK: - Props
extension MainViewController {
    enum Props {
        case loading
        case successCurrentWeather(data: CurrentWeather)
        case successWeatherPerHour(data: [WeatherPerHour])
        case successWeatherPerDay(data: [WeatherPerDay])
        case error(message: String)
    }
}

