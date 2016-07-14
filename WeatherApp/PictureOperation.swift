//
//  PictureOperation.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/11/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation
import UIKit

class PictureOperation: NSOperation {
    
    var place: Place?
    var task: NSURLSessionDataTask?
    var url: String?
    
    enum State {
        case Ready, Executing, Finished
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }
    
    var state: State {
        willSet {
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }
    
    init(url: String, place: Place) {
        self.url = url
        self.place = place
        self.state = .Ready
        super.init()
        
    }
    
    override func main() {
        if self.cancelled {
            self.state = .Finished
            return
        }
    }
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    override func start() {
        NSLog("💤 started sleeping")
        sleep(10)
        NSLog("🙄 woke up")
        if let cachedImageData = CacheManager.sharedInstance.cache.objectForKey(self.url!) {
            NSLog("Didn't download image \(self.url!) because it is cashed")
            self.place?.backgroundImageData = cachedImageData as! NSData
        } else {
            let url = NSURL(string: Constants.githubUrl + self.url!)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (responseData, responseUrl, error) -> Void in
                if let data = responseData {
                    CacheManager.sharedInstance.cache.setObject(data, forKey: self.url!)
                    self.place?.backgroundImageData = data
                    self.finish()
                } else {
                    self.cancel()
                }
            }
            task.resume()
        }
    }
    
    override func cancel() {
        self.state = .Finished
        self.task?.cancel()
        super.cancel()
    }
    
    func finish() {
        self.state = .Finished
    }
}
