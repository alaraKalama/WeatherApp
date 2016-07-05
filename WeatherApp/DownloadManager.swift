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
    func didFetchLocationForecastData(sender: DownloadManager)
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
        for place in places {
            self.getDataForPlace(place)
        }
    }
    
    func getDataWithLatitudeAndLongitude(latitudeString: String, longitudeString: String) {
        //TODO: move the logic in the func below
        
        let URLString = forecastCall + myAPIKey + "/" + latitudeString + "," + longitudeString
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
                print(myDATA.description)
                self.locationData = myDATA
                //self.delegate?.didFetchLocationForecastData(self)
                
            } catch {
                print("error trying to convert to JSON")
                return
            }
        })
        
        task.resume()
    }
    
    func getDataForPlace(place: Place) {
        //TODO: Data should be fetched here where we have the place object - this should be the main func for getting data
        if let latitude = place.latitude {
            if let longitude = place.longitute {
                self.getDataWithLatitudeAndLongitude(latitude, longitudeString: longitude)
                //Place.getPlaceFromJSON(self.locationData!, place: place)
            }
        }
        
    }
    
    func getDataForLocation(location: CLLocation) {
        //This is not called anywhere! Do I need it?
        let latitudeString = "\(location.coordinate.latitude)"
        let longitudeString = "\(location.coordinate.longitude)"
        self.getDataWithLatitudeAndLongitude(latitudeString, longitudeString: longitudeString)
        
    }
}