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
    func didFetchDataForAllPlaces(sender: DownloadManager)
}

class DownloadManager {
    
    var forecastsQueue: NSOperationQueue = NSOperationQueue()
    var downloadImagesQueue: NSOperationQueue = NSOperationQueue()

    var delegate: DownloadManagerDelegate?
    var locationData: [String:AnyObject]?
    
    static let sharedInstance = DownloadManager()
    private init() {
        
    }
    
    // MARK: - Forecast data downloading
    
    func fetchDataForPlaces(places: [Place]) {
        let doneOperation = NSOperation()
        doneOperation.completionBlock = {
            NSLog("doneOperation is done")
            self.delegate?.didFetchDataForAllPlaces(self)
        }
        for (index,place) in places.enumerate() {
            let weatherOperation = WeatherOperation(place: place)
            weatherOperation.completionBlock = {
                NSLog("Finished \(index) operation for \(place.name)")
            }
            doneOperation.addDependency(weatherOperation)
            self.forecastsQueue.addOperation(weatherOperation)
        }
        self.forecastsQueue.addOperation(doneOperation)
    }
    
    func downloadBackgroundImages(places:[Place]) {
        
        for (index,place) in places.enumerate() {
            var url: String
            if place.icon != nil {
                url = self.generateUrl(place)
                let downloadOperation = PictureOperation(url: url, place: place)
                downloadOperation.completionBlock = {
                    NSLog("Finished \(index) download image operation for place \(place.name!)")
                }
                self.downloadImagesQueue.addOperation(downloadOperation)
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
    
    func generateUrl(place: Place) -> String {
        var backgroundURL = String()
        if let icon = place.icon {
            switch icon {
            case Constants.clear_day:
                if place.currentTemperatureC >= 28 {
                    backgroundURL = Constants.hotDayUrl
                } else {
                    backgroundURL = Constants.cleardayUrl

                }
            case Constants.clear_night:
                backgroundURL = Constants.clearnightUrl
            case Constants.cloudy_day:
                backgroundURL = Constants.cloudydayUrl
            case Constants.cloudy_night:
                backgroundURL = Constants.cloudynightUrl
            case Constants.partly_cloudy_day:
                backgroundURL = Constants.partlycloudydayUrl
            case Constants.partly_cloudy_night:
                backgroundURL = Constants.cloudynightUrl
            case Constants.rain:
                backgroundURL = Constants.raindayUrl
            case Constants.sleet:
                backgroundURL = Constants.sleetUrl
            case Constants.snow:
                backgroundURL = Constants.snowdayUrl
            case Constants.fog:
                backgroundURL = Constants.fogUrl
            default:
                backgroundURL = Constants.cleardayUrl
            }
        }
        return Constants.githubUrl + backgroundURL
    }
}