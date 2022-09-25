//
//  ImageMatcher.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import Foundation

enum ImageMatcher: String {
    case cleanDay = "ic_white_day_bright"
    case cloudsDay = "ic_white_day_cloudy"
    case rainDay = "ic_white_day_rain"
    case snowDay = "ic_white_day_shower"
    case thunderDay = "ic_white_day_thunder"
    case cleanNight = "ic_white_night_bright"
    case cloudsNight = "ic_white_night_cloudy"
    case rainNight = "ic_white_night_rain"
    case snowNight = "ic_white_night_shower"
    case thunderNight = "ic_white_night_thunder"
    
    init(rawValue: String) {
        switch rawValue {
        case "01d":
            self = .cleanDay
        case "02d":
            self = .cloudsDay
        case "09d":
            self = .rainDay
        case "10d":
            self = .rainDay
        case "11d":
            self = .thunderDay
        case "13d":
            self = .snowDay
        case "01n":
            self = .cleanNight
        case "02n":
            self = .cloudsNight
        case "09n":
            self = .rainNight
        case "10n":
            self = .rainNight
        case "11n":
            self = .thunderNight
        case "13n":
            self = .thunderNight
        default:
            self = .cloudsDay
        }
    }
}
