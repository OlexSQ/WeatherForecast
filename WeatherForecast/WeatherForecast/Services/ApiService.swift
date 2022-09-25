//
//  ApiService.swift
//  WeatherForecast
//
//  Created by Mac on 23.09.2022.
//

import Foundation

protocol ApiService {
    func getWeatherData(for location: String, comletionHandler: @escaping(Result <WeatherData, Error>) -> Void)
}

class ApiServiceImplementation: ApiService {
    private let baseUrlString = "https://api.openweathermap.org/data/2.5/forecast?id=524901&lang=ua&appid=e83bce43f40758140ef6927fda5cfc85&units=metric"
    
    func getWeatherData(for location: String, comletionHandler: @escaping(Result <WeatherData, Error>) -> Void) {
        let fullUrl = baseUrlString + "\(location)"
        guard let url = URL(string: fullUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data, error == nil {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    comletionHandler(.success(weatherData))
                } catch let error {
                    comletionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
