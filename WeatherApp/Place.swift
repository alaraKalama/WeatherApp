//
//  Place.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//



import Foundation

class Place {
    
    static let conversionManager = UnitConversionManager()
    
    // MARK: - properties
    
    var name: String?
    var latitude: String?
    var longitude: String?
    var isCurrentLocation: Bool! = false
    var currentTemperature: Int?
    var feelsLikeTemperature: Int?
    var humidity: Int?
    var visibility: Double?
    var pressure: Double?
    var precipitation: Int?
    var precipType: String?
    var windSpeed: Double?
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
        }
        if let currentWather = json[Constants.currently] as? NSDictionary {
            NSLog(place.name!)
            print(currentWather)
            if let temperatureInFahrenheit = currentWather[Constants.temperature] as? Int {
                //C
                place.currentTemperature = conversionManager.FahrenheitToCelsius(temperatureInFahrenheit)
            }
            if let feelsLike = currentWather[Constants.feelsLike] as? Int {
                //C
                place.feelsLikeTemperature = conversionManager.FahrenheitToCelsius(feelsLike)
            }
            if let humidity = currentWather[Constants.humidity] as? Double {
                //%
                place.humidity = Int(humidity * 100) % 100
            }
            if let visibility = currentWather[Constants.visibility] as? Double {
                //km
                place.visibility = conversionManager.milesToKilometers(visibility)
            }
            if let pressure = currentWather[Constants.pressure] as? Double {
                //mb
                place.pressure = pressure
            }
            if let precipitation = currentWather[Constants.precipProbability] as? Double {
                place.precipitation = Int(precipitation * 100) % 100
            }
            if let precipType = currentWather[Constants.precipType] as? String {
                place.precipType = precipType
            }
            if let windSpeed = currentWather[Constants.windSpeed] as? Double {
                place.windSpeed = conversionManager.milesToKilometers(windSpeed)
            }
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