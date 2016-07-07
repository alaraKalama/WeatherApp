//
//  PlaceTableViewCell.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeNowLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func createFromPLace(place: Place, cell: PlaceTableViewCell) {
        if let name = place.name {
            cell.placeLabel.text = name
        } else {
            cell.placeLabel.text = ""
        }
        
        if let temp = place.currentTemperature {
            cell.temperatureLabel.text = "\(temp)"
        }
        
        if let icon = place.icon{
            cell.iconImageView.image = UIImage(named: icon)
        }
        
        if let summary = place.summary {
            cell.summary.text = summary
        }
        
        if let date = place.currentTime {
            let dayTimePeriodFormatter = NSDateFormatter()
            let timeZone = NSTimeZone(name: place.timezone!)
            dayTimePeriodFormatter.dateFormat = Constants.dayHoursMinutes
            dayTimePeriodFormatter.timeZone = timeZone
            let dateString = dayTimePeriodFormatter.stringFromDate(date)
            cell.timeNowLabel.text = dateString
            
            if dateString.hasSuffix("AM") {
                
            } else if dateString.hasSuffix("PM") {
                
            }
        }
        
        

        
    }

}
