//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by Mac on 23.09.2022.
//

import Foundation
import CoreLocation

protocol MainViewModel {
    var render: ((MainViewController.Props) -> Void)? { get set }
    func bind()
    func showWeatherForecastFor(_ location: LocationElement)
}

class MainViewModelImplementation: MainViewModel {
    var render: ((MainViewController.Props) -> Void)?
    var apiService: ApiService?
    var locationManager: LocationManager?
    
    func bind() {
        getCurrentLocation()
        locationManager?.updateLocation = { [weak self] coordinates in
            self?.getWeatherForecast(for: coordinates)
        }
    }
    
    func showWeatherForecastFor(_ location: LocationElement) {
        let coordinates = "&lat=\(location.lat)&lon=\(location.lng)"
        getWeatherForecast(for: coordinates)
    }
    
    private func getWeatherForecast(for location: String) {
        apiService?.getWeatherData(for: location) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                self?.parseWeatherData(data)
            case .failure(let error):
                self?.render?(.error(message: error.localizedDescription))
            }
        }
    }
    
    private func parseWeatherData(_ data: WeatherData) {
        extractCurrentWeather(from: data)
        extractWeatherPerHour(from: data)
        extractWeatherPerDay(from: data)
    }
    
    private func extractCurrentWeather(from weatherData: WeatherData) {
        let location = weatherData.city.name
        let date = weatherData.list.first?.dtTxt ?? ""
        let formatedDate = formateDate(from: date, dateFormat: .current)
        let maxTemp = "\(Int(weatherData.list.first?.main.tempMax.rounded(.up) ?? 0.00))°"
        let minTemp = "\(Int(weatherData.list.first?.main.tempMin.rounded(.down) ?? 0.00))°"
        let wind = "\(weatherData.list.first?.wind.speed ?? 0.00) м/сек↗︎"
        let humidity = "\(weatherData.list.first?.main.humidity ?? 0)%"
        let image = weatherData.list.first?.weather.first?.icon ?? "02d"
        
        let currentWeather = CurrentWeather(image: ImageMatcher(rawValue: image).rawValue, location: location, date: formatedDate, maxTemp: maxTemp, minTemp: minTemp, wind: wind, humidity: humidity)
        render?(.successCurrentWeather(data: currentWeather))
    }
    
    private func extractWeatherPerHour(from weatherData: WeatherData) {
        var weatherPerHour = [WeatherPerHour]()
        let limit = 10
        for forecast in weatherData.list {
            let date = forecast.dtTxt
            let formatedDate = formateDate(from: date, dateFormat: .hour)
            let image = forecast.weather.first?.icon ?? "02d"
            let temp = "\(Int(forecast.main.temp))°"
            let weather = WeatherPerHour(image: ImageMatcher(rawValue: image).rawValue, time: formatedDate, temp: temp)
            weatherPerHour.append(weather)
            
            if weatherPerHour.count == limit { break }
        }
        render?(.successWeatherPerHour(data: weatherPerHour))
    }
    
    private func extractWeatherPerDay(from weatherData: WeatherData) {
        var weatherPerDay = [WeatherPerDay]()
        weatherData.list.forEach { forecast in
            if (forecast.dtTxt.contains("12:00")) {
                let date = forecast.dtTxt
                let formatedDate = formateDate(from: date, dateFormat: .day)
                let image = forecast.weather.first?.icon ?? "02d"
                let minTemp = "\(Int(forecast.main.tempMin.rounded(.down)))"
                let maxTemp = "\(Int(forecast.main.tempMax.rounded(.up)))"
                let weather = WeatherPerDay(image: ImageMatcher(rawValue: image).rawValue, date: formatedDate, maxTemp: maxTemp, minTemp: minTemp)
                weatherPerDay.append(weather)
            }
        }
        render?(.successWeatherPerDay(data: weatherPerDay))
    }
    
    private func formateDate(from date: String, dateFormat: DateFormat) -> String {
        let dateFormatterFrom = DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = dateFormat.rawValue
        
        if let date = dateFormatterFrom.date(from: date) {
            return dateFormatterTo.string(from: date)
        } else {
            return date
        }
    }
    
    private func getCurrentLocation() {
        locationManager?.getCurrentUserLocation()
    }
}

extension MainViewModelImplementation {
    enum DateFormat: String {
        case current = "E, d MMMM"
        case hour = "HH:MM"
        case day = "E"
    }
}
