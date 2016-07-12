//
//  constants.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/6/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: - file names
    
    static let plistFileName = "Places"
    static let plist = "plist"
    
    // MARK: - place json properties
    
    static let timezone = "timezone"
    static let temperature = "temperature"
    static let feelsLike = "apparentTemperature"
    static let currently = "currently"
    static let cloudCover = "cloudCover"
    static let dewPoint = "dewPoint"
    static let humidity = "humidity"
    static let icon = "icon"
    static let ozone = "ozone"
    static let precipIntensity = "precipIntensity"
    static let precipProbability = "precipProbability"
    static let precipType = "precipType"
    static let pressure = "pressure"
    static let summary = "summary"
    static let time = "time"
    static let visibility = "visibility"
    static let windBearing = "windBearing"
    static let windSpeed = "windSpeed"
    static let hourly = "hourly"
    static let daily = "daily"
    static let latitude = "latitude"
    static let longitude = "longitude"
    
    //MARK: - icon strings
    
    static let clear_day = "clear-day"
    static let clear_night = "clear-night"
    static let cloudy_day = "cloudy-day"
    static let cloudy_night = "cloudy-night"
    static let fog = "fog"
    static let partly_cloudy_day = "partly-cloudy-day"
    static let partly_cloudy_night = "partly-cloudy-night"
    static let rain = "rain"
    static let sleet = "sleet"
    static let snow = "snow"
    static let wind = "wind"
    
    // MARK: - urls
    
    static let myAPIKey = "65865cb85a8f5c9962bf4f514bd1a12d"
    static let forecastCall = "https://api.forecast.io/forecast/"
    static let githubUrl = "https://raw.githubusercontent.com/alaraKalama/WeatherApp/master/weather%20backgrounds/"
    static let cleardayUrl = "clear-day.png"
    static let hotDayUrl = "hot-day.png"
    static let clearnightUrl = "clear-night2.png"
    static let cloudydayUrl = "cloudy-day.png"
    static let cloudynightUrl = "cloudy-night.png"
    static let fogUrl = "fog2.png"
    static let partlycloudydayUrl = "partly-cloudy-day.jpg"
    static let raindayUrl = "rain-day.png"
    static let rainnightUrl = "rain-night.png"
    static let sleetUrl = "sleet.png"
    static let snowdayUrl = "snow-day2.png"
    static let windydayUrl = "windy-day.png"
    static let windynightUrl = "windy-night.png"
    static let tablebackgroundUrl = "table-background.png"
    
    
    //MARK: - others
    
    static let textCellIdentifier = "placeCell"
    static let City = "City"
    static let dayHoursMinutes = "EEEE, hh:mm a"
}