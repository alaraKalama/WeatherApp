//
//  DetailsView.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/7/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class DetailsView: UIView {
    
    let downloadManager = DownloadManager.sharedInstance

    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
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
        downloadManager.downloadImage(Constants.githubUrl + Constants.cloudydayUrl, view: self.backgroundImageView)
        self.summaryLabel.text = place.summary
        self.iconView.image = UIImage(named: place.icon!)
        
//        if let humidity = place.humidity {
//            self.humidityValueLabel.text = "\(humidity)%"
//        }
//
//        if GlobalUnit.sharedManager.isCelsiusSystem {
//            if let temp = place.currentTemperatureC {
//                self.temperatureLabel.text = "\(temp)°C"
//            }
//            if let feelsLike = place.feelsLikeTemperatureC {
//                self.feelsLikeValueLabel.text = "\(feelsLike)°C"
//            }
//            if let visibility = place.visibilityKm {
//                //\(someDouble.format(.1))"
//                self.visibilityValueLabel.text = String(format: "%.1f km", visibility)
//            }
//            if let pressure = place.pressureMb {
//                self.pressureValueLabel.text = "\(Int(pressure)) mb"
//            }
//            if let windSpeed = place.windSpeedKm {
//                self.windSpeedValueLabel.text = String(format: "%.1f km/h", windSpeed)
//            }
//        } else {
//            if let temp = place.currentTemperatureF {
//                self.temperatureLabel.text = "\(temp)°F"
//            }
//            if let feelsLike = place.feelsLikeTemperatureF {
//                self.feelsLikeValueLabel.text = "\(feelsLike)°C"
//            }
//            if let visibility = place.visibilityMi {
//                //\(someDouble.format(.1))"
//                self.visibilityValueLabel.text = String(format: "%.1f mi", visibility)
//            }
//            if let pressure = place.pressureIn {
//                self.pressureValueLabel.text = "\(Int(pressure)) in"
//            }
//            if let windSpeed = place.windSpeedMi {
//                self.windSpeedValueLabel.text = String(format: "%.1f mi/h", windSpeed)
//            }
//        }
    }
}
