//
//  Place.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class Place {
    
    var name: String!
    var latitude: String!
    var longitute: String!
    var currentTemperature: Int!
    var currentTime: NSDate!
    
    static func getPlaceFromDictionary(dict: NSDictionary) -> Place {
        let place = Place()
        return place
    }
}
