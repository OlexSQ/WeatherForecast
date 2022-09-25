//
//  SearchLocationViewModel.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import Foundation

protocol SearchLocationViewModel {
    var render: ((Location) -> Void)? { get set }
    func findLocation(_ location: String)
    
}

class SearchLocationViewModelImplementation: SearchLocationViewModel {
    private let countriesFileName = "cities"
    private lazy var cities = loadJson(filename: countriesFileName)
    var render: ((Location) -> Void)?
    
    func findLocation(_ location: String) {
        if location.isEmpty {
            render?([])
        } else if location.count >= 3 {
            getSimilarLocationsFromFile(location: location)
        }
    }
    
    private func getSimilarLocationsFromFile(location: String) {
        var locations = Location()
        cities?.forEach { city in
            if city.name.contains(location) {
                locations.append(city)
            }
        }
        render?(locations)
    }
    
    private func loadJson(filename fileName: String) -> Location? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Location.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
