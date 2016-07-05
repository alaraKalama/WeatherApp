//
//  Place.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class Place {
    
    var name: String?
    var latitude: String?
    var longitute: String?
    var isCurrentLocation: Bool! = false
    var currentTemperature: Int?
    var icon: String?
    
    var currentTime: NSDate!
    
    static func getPlacesFromDictionary(dict: NSDictionary) -> [Place] {
        var places = [Place]()
        
        for dictPlace in dict.enumerate() {
            let place = Place()
            place.name = dictPlace.element.key as? String
            let placeProperties = dictPlace.element.value
            if let propsDict: Dictionary<String, String> = placeProperties as? Dictionary<String, String> {
                place.latitude = propsDict["latitude"]
                place.longitute = propsDict["longitude"]
            }
            places.append(place)
        }
        return places
    }
    
    static func getPlaceFromJSON(data: [String: AnyObject], place: Place) {
        
    }
}