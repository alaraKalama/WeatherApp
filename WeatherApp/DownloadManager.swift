//
//  DownloadManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation
import CoreLocation

protocol DownloadManagerDelegate: class {

    func didFetchDataForPlaceAtIndex(index: NSInteger)
}

class DownloadManager {
    
    let myAPIKey = "65865cb85a8f5c9962bf4f514bd1a12d"
    let forecastCall = "https://api.forecast.io/forecast/"
    
    var delegate: DownloadManagerDelegate?
    var locationData: [String:AnyObject]?
    
    static let sharedInstance = DownloadManager()
    private init() {
        
    }
    
    func fetchDataForPlaces(places: [Place]) {
        for (index,place) in places.enumerate() {
            self.getDataForPlace(place, atIndex: index)
        }
    }
    
    func getDataForPlace(place: Place, atIndex: NSInteger) {
        //TODO: Data should be fetched here where we have the place object - this should be the main func for getting data
        if let latitude = place.latitude {
            if let longitude = place.longitude {
                
                let URLString = forecastCall + myAPIKey + "/" + latitude + "," + longitude
                
                guard let url = NSURL(string: URLString) else {
                    NSLog("Error: Cannot create url from string")
                    return
                }
                
                let urlRequest = NSURLRequest(URL: url)
                
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        NSLog("Error calling GET on @% ->", URLString)
                        print(error)
                        return
                    }
                    guard let responseData = data else {
                        NSLog("Error: did not recieve data")
                        return
                    }
                    do {
                        guard let myDATA = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                            return
                        }
                        Place.getPlaceFromJSON(myDATA, place: place)
                        self.delegate?.didFetchDataForPlaceAtIndex(atIndex)
                        
                    } catch {
                        print("error trying to convert to JSON")
                        return
                    }
                })
                
                task.resume()
            }
        }
        
    }
}