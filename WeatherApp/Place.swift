//
//  Place.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//



import Foundation
import UIKit

class Place {
    
    static let conversionManager = UnitConversionManager()
    
    // MARK: - properties
    
    var name: String?
    var latitude: String?
    var longitude: String?
    var isCurrentLocation: Bool! = false
    var currentTemperatureC: Int?
    var currentTemperatureF: Int?
    var feelsLikeTemperatureC: Int?
    var feelsLikeTemperatureF: Int?
    var humidity: Int?
    var visibilityKm: Double?
    var visibilityMi: Double?
    var pressureMb: Double?
    var pressureIn: Double?
    var precipitation: Int?
    var precipType: String?
    var windSpeedKm: Double?
    var windSpeedMi: Double?
    var icon: String?
    var currentTime: NSDate?
    var timezone: String?
    var summary: String?
    var hourly: [String:AnyObject]?
    var backgroundImageData = NSData()
    
    //MARK: - Functions
    
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
    
    static func getPlaceFromJSON(json: [String: AnyObject], place: Place) {
        if let timezone = json[Constants.timezone] as? String {
            place.timezone = timezone
        }
//        if let hourly = json[Constants.hourly] as? [String:AnyObject] {
//            //TODO!!!
//            place.hourly = hourly
//            let summary = hourly["summary"] as? String
//            let icon = hourly[Constants.icon] as? String
//            let data = hourly["data"] as? NSDictionary
//            print("YAY")
//        }
//        if let daily = json[Constants.daily] as? NSDictionary {
//            
//        }
        if let currentWather = json[Constants.currently] as? NSDictionary {
            NSLog(place.name!)
            print(currentWather)
            if let temperatureInFahrenheit = currentWather[Constants.temperature] as? Int {
                place.currentTemperatureF = temperatureInFahrenheit
                place.currentTemperatureC = conversionManager.FahrenheitToCelsius(temperatureInFahrenheit)
            }
            if let feelsLike = currentWather[Constants.feelsLike] as? Int {
                place.feelsLikeTemperatureF = feelsLike
                place.feelsLikeTemperatureC = conversionManager.FahrenheitToCelsius(feelsLike)
            }
            if let humidity = currentWather[Constants.humidity] as? Double {
                place.humidity = Int(humidity * 100) % 100
            }
            if let visibility = currentWather[Constants.visibility] as? Double {
                place.visibilityMi = visibility
                place.visibilityKm = conversionManager.milesToKilometers(visibility)
            }
            if let pressure = currentWather[Constants.pressure] as? Double {
                place.pressureMb = pressure
                place.pressureIn = conversionManager.milibarsToInches(pressure)
            }
            if let precipitation = currentWather[Constants.precipProbability] as? Double {
                place.precipitation = Int(precipitation * 100) % 100
            }
            if let precipType = currentWather[Constants.precipType] as? String {
                place.precipType = precipType
            }
            if let windSpeed = currentWather[Constants.windSpeed] as? Double {
                place.windSpeedMi = windSpeed
                place.windSpeedKm = conversionManager.milesToKilometers(windSpeed)
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