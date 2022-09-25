//
//  Contries.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import Foundation

// MARK: - LocationElement
struct LocationElement: Codable {
    let country, name, lat, lng: String
}

typealias Location = [LocationElement]
