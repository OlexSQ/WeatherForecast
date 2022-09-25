//
//  OneHourCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import UIKit

class OneHourCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func render(with data: WeatherPerHour) {
        timeLabel.text = data.time
        iconImageView.image = UIImage(named: data.image)
        tempLabel.text = data.temp
    }
}
