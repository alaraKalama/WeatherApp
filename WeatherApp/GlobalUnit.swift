//
//  GlobalUnit.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/8/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class GlobalUnit {
    
    var isCelsiusSystem: Bool = true
    
    class var sharedManager: GlobalUnit {
        struct Static {
            static let instance = GlobalUnit()
        }
        return Static.instance
    }
}
