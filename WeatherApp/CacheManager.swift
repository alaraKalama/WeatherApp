//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/12/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let sharedInstance = CacheManager()
    
    private init() {
    }
    
    let cache = NSCache()    
}