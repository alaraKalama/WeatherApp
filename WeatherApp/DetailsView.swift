//
//  DetailsView.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/7/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class DetailsView: UIView {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var feelsLikeValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var visibilityValueLabel: UILabel!
    @IBOutlet weak var chanceOfDescriptionLabel: UILabel!
    @IBOutlet weak var chanceOfValueLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    
    func displayPlaceInfo(place: Place) {
        self.summaryLabel.text = place.summary
        if let temp = place.currentTemperature {
            self.temperatureLabel.text = "\(temp)"
        }
        self.iconView.image = UIImage(named: place.icon!)
        if let feelsLike = place.feelsLikeTemperature {
            self.feelsLikeValueLabel.text = "\(feelsLike)"
        }
        if let humidity = place.humidity {
            self.humidityValueLabel.text = "\(humidity)"

        }
        if let visibility = place.visibility {
            self.visibilityValueLabel.text = "\(visibility)"

        }
        if let pressure = place.pressure {
            self.pressureValueLabel.text = "\(pressure)"

        }
        if let windSpeed = place.windSpeed {
            self.windSpeedValueLabel.text = "\(windSpeed)"

        }
    }
}
