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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createFromPLace(place: Place) {
        
    }

}
