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
    
    override init() {
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
        
    }


    
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
