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

@objc protocol DownloadManagerDelegate: class {

    optional func didFetchDataForAllPlaces(sender: DownloadManager)
    optional func didDownloadBackgroundImage(sender: DownloadManager)
 }

class DownloadManager : NSObject {
    
    var forecastsQueue: NSOperationQueue = NSOperationQueue()
    var downloadImagesQueue: NSOperationQueue = NSOperationQueue()

    var delegate: DownloadManagerDelegate?
    var locationData: [String:AnyObject]?
    
    static let sharedInstance = DownloadManager()
    private override init() {
        super.init()
        self.forecastsQueue.addObserver(self, forKeyPath: "operations", options: .New, context: nil)
    }
    
    deinit {
        self.forecastsQueue.removeObserver(self, forKeyPath: "operations")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object != nil && object! as! NSObject == self.forecastsQueue && keyPath != nil && keyPath! == "operations" {
            if self.forecastsQueue.operations.count == 0 {
                NSLog("all done")
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - Forecast data downloading
    
    func fetchDataForPlaces(places: [Place]) {
        
        let doneOperation = NSOperation()
        doneOperation.completionBlock = {
            NSLog("doneOperation is done")
            self.delegate?.didFetchDataForAllPlaces!(self)
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
    
    // MARK: - Background images downloading
    
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
    
    func downloadTableVCBackgroundImage(url: String, tableVC: PlacesViewController) {
        //TODO; cache those images
        if let cachedData = CacheManager.sharedInstance.cache.valueForKey(Constants.tablebackgroundUrl) {
            tableVC.backgroundImageData = cachedData as? NSData
            self.delegate?.didDownloadBackgroundImage!(self)
        } else {
            let url = NSURL(string: url)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (responseData, responseUrl, error) -> Void in
                if let fetchedData = responseData {
                    tableVC.backgroundImageData = fetchedData
                    self.delegate?.didDownloadBackgroundImage!(self)
                } else {
                    NSLog("Somethings wrong -> \(error?.description)")
                }
            }
            task.resume()
        }
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
        return backgroundURL
    }
}