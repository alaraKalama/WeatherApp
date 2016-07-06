//
//  PlistManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/1/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation


struct Plist {
    
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    
    let name:String
    
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: Constants.plist) else { return .None }
        return path
    }
    
    var destPath:String? {
        guard sourcePath != .None else { return .None }
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).\(Constants.plist)")
    }
    
    init?(name:String) {
        
        self.name = name
        
        let fileManager = NSFileManager.defaultManager()
        
        guard let source = sourcePath else { return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExistsAtPath(source) else { return nil }
        
        if !fileManager.fileExistsAtPath(destination) {
            
            do {
                try fileManager.copyItemAtPath(source, toPath: destination)
            } catch let error as NSError {
                print("[PlistManager] Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
}

class PlistManager {

    static let sharedInstance = PlistManager()
    private init() {}
    
    func startPlistManager() {
        if let _ = Plist(name: Constants.plistFileName) {
            print("[PlistManager] PlistManager started")
        }
    }
    
    // MARK: - places methods
    
    func getAllPlaces() -> [Place] {
        var places: [Place] = []
        var placesDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource(Constants.plistFileName, ofType: Constants.plist) {
            placesDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = placesDict {
            places = Place.getPlacesFromDictionary(dict)
        }
        return places
    }
}