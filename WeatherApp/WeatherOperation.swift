//
//  WeatherOperation.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/11/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

class WeatherOperation: NSOperation {
    
    var place: Place
    var task: NSURLSessionDataTask?
    
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
    
    init(place: Place) {
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
        
        self.state = State.Ready
        
        if let latitude = self.place.latitude, longitude = self.place.longitude {
                
            let URLString = Constants.forecastCall + Constants.myAPIKey + "/" + latitude + "," + longitude
            
            guard let url = NSURL(string: URLString) else {
                NSLog("Error: Cannot create url from string")
                self.cancel()
                return
            }
            
            let urlRequest = NSURLRequest(URL: url)
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            self.task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    NSLog("Error calling GET on @% ->", URLString)
                    print(error)
                    self.cancel()
                    return
                }
                guard let responseData = data else {
                    NSLog("Error: did not recieve data")
                    self.cancel()
                    return
                }
                do {
                    guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                        self.cancel()
                        return
                    }
                    Place.getPlaceFromJSON(json, place: self.place)
                    self.finish()
                } catch {
                    print("error trying to convert to JSON")
                    self.cancel()
                    return
                }
            })
            self.task!.resume()
        } else {
            self.cancel()
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
