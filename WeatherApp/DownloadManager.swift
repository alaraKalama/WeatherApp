//
//  DownloadManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class DownloadManager {
    
    var data: Dictionary<String, Dictionary<String, String>> = [
        "London" : [
            "temperature":"23",
            "time":"10:54"
        ],
        "Paris" : [
            "temperature":"28",
            "time":"11:54"
        ],
        "Sofia" : [
            "temperature":"29",
            "time":"12:54"
        ],
        
        ]
    
    func getData() -> Dictionary<String, Dictionary<String, String>> {
        return data
    }
}