//
//  TemperatureManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/6/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation
//T(°C) = (T(°F) - 32) / 1.8
//T(°F) = T(°C) × 1.8 + 32

class UnitConversionManager {
    
    // MARK: - Temperature conversions
    
    func FahrenheitToCelsius(fahrenheit: Int) -> Int {
        let celsius = (Double)(fahrenheit - 32) * 0.56
        return Int(celsius)
    }
    
    func CelsiusToFahrenheit(celsius: Int) -> Int {
        let fahrenheit = (Double)(celsius) * 1.8 + 32
        return Int(fahrenheit)
    }
    
    // MARK: - Distance conversions
    
    func milesToKilometers(miles: Double) -> Double {
        let km = miles / 0.62137
        return km
    }
    
    func kilometersToMiles() {
        
    }
    
    func inchesToCentimeters() {
    
    }
    
    func centimetersToInches() {
        
    }
    
    // MARK: - Pressure conversions
    
    func milibarsToInches() {
        
    }
    
    func inchesToMilibars() {
        
    }
}