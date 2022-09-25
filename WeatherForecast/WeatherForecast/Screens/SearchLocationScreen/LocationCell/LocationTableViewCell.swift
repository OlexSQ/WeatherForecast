//
//  LocationTableViewCell.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    func render(with location: LocationElement) {
        locationLabel.text = "\(location.name), \(location.country)"
    }
}
