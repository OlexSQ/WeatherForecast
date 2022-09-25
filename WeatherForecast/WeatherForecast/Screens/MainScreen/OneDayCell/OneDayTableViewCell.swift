//
//  OneDayTableViewCell.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import UIKit

class OneDayTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func render(with data: WeatherPerDay) {
        dayLabel.text = data.date
        tempLabel.text = "\(data.maxTemp)°/\(data.minTemp)°"
        iconImageView.image = UIImage(named: data.image)
    }
}
