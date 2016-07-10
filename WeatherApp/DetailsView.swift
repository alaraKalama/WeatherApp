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
    @IBOutlet weak var timeLabel: UILabel!
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
        self.iconView.image = UIImage(named: place.icon!)
        
        if let date = place.currentTime {
            //TODO: this func should be exported in one place for all usages
            let dayTimePeriodFormatter = NSDateFormatter()
            let timeZone = NSTimeZone(name: place.timezone!)
            dayTimePeriodFormatter.dateFormat = Constants.dayHoursMinutes
            dayTimePeriodFormatter.timeZone = timeZone
            let dateString = dayTimePeriodFormatter.stringFromDate(date)
            self.timeLabel.text = dateString
        }
        
        if let humidity = place.humidity {
            self.humidityValueLabel.text = "\(humidity)%"
        }
        
        if let precipProbability = place.precipitation {
            self.chanceOfValueLabel.text = "\(precipProbability) %"
        }
        if let precipType = place.precipType {
            self.chanceOfDescriptionLabel.text = "Chance of \(precipType)"
        } else {
            self.chanceOfDescriptionLabel.text = "Chance of rain"
        }

        if GlobalUnit.sharedManager.isCelsiusSystem {
            if let temp = place.currentTemperatureC {
                self.temperatureLabel.text = "\(temp)°C"
            }
            if let feelsLike = place.feelsLikeTemperatureC {
                self.feelsLikeValueLabel.text = "\(feelsLike)°C"
            }
            if let visibility = place.visibilityKm {
                self.visibilityValueLabel.text = String(format: "%.1f km", visibility)
            }
            if let pressure = place.pressureMb {
                self.pressureValueLabel.text = "\(Int(pressure)) mb"
            }
            if let windSpeed = place.windSpeedKm {
                self.windSpeedValueLabel.text = String(format: "%.1f km/h", windSpeed)
            }
        } else {
            if let temp = place.currentTemperatureF {
                self.temperatureLabel.text = "\(temp)°F"
            }
            if let feelsLike = place.feelsLikeTemperatureF {
                self.feelsLikeValueLabel.text = "\(feelsLike)°C"
            }
            if let visibility = place.visibilityMi {
                self.visibilityValueLabel.text = String(format: "%.1f mi", visibility)
            }
            if let pressure = place.pressureIn {
                self.pressureValueLabel.text = "\(Int(pressure)) in"
            }
            if let windSpeed = place.windSpeedMi {
                self.windSpeedValueLabel.text = String(format: "%.1f mi/h", windSpeed)
            }
        }
    }
}
