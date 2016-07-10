//
//  DownloadManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol DownloadManagerDelegate: class {

    //TODO: Add sender as param
    func didFetchDataForPlaceAtIndex(index: NSInteger)
}

class DownloadManager {
    
    var delegate: DownloadManagerDelegate?
    var locationData: [String:AnyObject]?
    
    static let sharedInstance = DownloadManager()
    private init() {
        
    }
    
    // MARK: - Forecast data downloading
    
    func fetchDataForPlaces(places: [Place]) {
        for (index,place) in places.enumerate() {
            self.getDataForPlace(place, atIndex: index)
        }
    }
    
    func getDataForPlace(place: Place, atIndex: NSInteger) {
        if let latitude = place.latitude {
            if let longitude = place.longitude {
                
                let URLString = Constants.forecastCall + Constants.myAPIKey + "/" + latitude + "," + longitude
                
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
                        guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                            return
                        }
                        Place.getPlaceFromJSON(json, place: place)
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
    
    // MARK: - Background images downloading
    
    func downloadImage(url: String, view: UIImageView) {
        //TODO; cache those images
        let url = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (responseData, responseUrl, error) -> Void in
            if let data = responseData {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }
    
    

}