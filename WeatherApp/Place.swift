//
//  Place.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//



import Foundation

class Place {
    
    static let temperatureManager = TemperatureManager()
    
    // MARK: - properties
    
    var name: String?
    var latitude: String?
    var longitude: String?
    var isCurrentLocation: Bool! = false
    var currentTemperature: Int?
    var icon: String?
    var currentTime: NSDate?
    var timezone: String?
    var summary: String?
    
    static func getPlacesFromDictionary(dict: NSDictionary) -> [Place] {
        var places = [Place]()
        
        for dictPlace in dict.enumerate() {
            let place = Place()
            place.name = dictPlace.element.key as? String
            let placeProperties = dictPlace.element.value
            if let propsDict: Dictionary<String, String> = placeProperties as? Dictionary<String, String> {
                place.latitude = propsDict[Constants.latitude]
                place.longitude = propsDict[Constants.longitude]
            }
            places.append(place)
        }
        return places
    }
    
    //currently
    //apparentTemperature = "77.86";
    //cloudCover = "0.19";
    //dewPoint = "71.31";
    //humidity = "0.8";
    //icon = "clear-day";
    //ozone = "286.11";
    //precipIntensity = 0;
    //precipProbability = 0;
    //pressure = "1014.05";
    //summary = Clear;
    //temperature = "77.86";
    //time = 1467794539;
    //visibility = "6.21";
    //windBearing = 188;
    //windSpeed = "10.65";
    
    static func getPlaceFromJSON(json: [String: AnyObject], place: Place) {
        if let timezone = json[Constants.timezone] as? String {
            place.timezone = timezone
            var formatter = NSDateFormatter()
            //formatter.timeZone = NSTimeZone.with
        }
        if let currentWather = json[Constants.currently] as? NSDictionary {
            NSLog(place.name!)
            print(currentWather)
            let temperatureInFahrenheit = currentWather[Constants.temperature] as? Int
            let temperatureInCelsius = temperatureManager.FahrenheitToCelsius(temperatureInFahrenheit!)
            place.currentTemperature = temperatureInCelsius
            if let icon = currentWather[Constants.icon] as? String {
                place.icon = icon
            }
            if let summary = currentWather[Constants.summary] as? String {
                place.summary = summary
            }
            
            if let secondsSince1970 = currentWather[Constants.time] as? NSTimeInterval {
                let date = NSDate(timeIntervalSince1970: secondsSince1970)
                place.currentTime = date
            }
            
        }
        
    }
}