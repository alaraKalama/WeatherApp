//
//  PlistManager.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/1/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import Foundation

let plistFileName: String = "Places"
let plist:String = "plist"
let latitude: String = "latitude"
let longitude: String = "longitude"

struct Plist {
    
    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    
    let name:String
    
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else { return .None }
        return path
    }
    
    var destPath:String? {
        guard sourcePath != .None else { return .None }
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
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
    
    func getValuesInPlistFile() -> NSDictionary?{
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    func getMutablePlistFile() -> NSMutableDictionary?{
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .None }
            return dict
        } else {
            return .None
        }
    }
    
    func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destPath!) {
            if !dictionary.writeToFile(destPath!, atomically: false) {
                print("[PlistManager] File not written successfully")
                throw PlistError.FileNotWritten
            }
        } else {
            throw PlistError.FileDoesNotExist
        }
    }
    
}


class PlistManager {

    static let sharedInstance = PlistManager()
    private init() {}
    
    func startPlistManager() {
        if let _ = Plist(name: plistFileName) {
            print("[PlistManager] PlistManager started")
        }
    }
    
    // MARK: - places methods
    
    func getAllPlaces() -> [Place] {
        var places: [Place] = []
        let allKeys = self.getAllKeys()
        for key in allKeys {
            let place = Place()
            place.name = key
            if let placeDict = PlistManager.sharedInstance.getValueForKey(key) {
                let placePropertiesKeys = placeDict.allKeys
                if placePropertiesKeys.count != 0 {
                    for property in placePropertiesKeys {
                        if property as! String == latitude {
                            if let value = placeDict[property as! String] {
                                place.latitude = value as! String
                            }
                        } else if property as! String == longitude {
                            if let value = placeDict[property as! String] {
                                place.longitute = value as! String
                            }
                        }
                        print(property)
                    }
                }
            }
            places.append(place)
        }
        return places
    }

    
    // MARK: - key/value private methods
    
    private func getAllKeys() ->[String]{
        var result = [String]()
        if let plist = Plist(name: plistFileName) {
            let dict = plist.getMutablePlistFile()!
            
            let keys = Array(dict.allKeys)
            if keys.count != 0 {
                for (_,element) in keys.enumerate() {
                    result.append(element as! String)
                }
            }
            return result
        } else {
            return result
        }
    }
    
    
    private func getValueForKey(key:String) -> AnyObject? {
        var value:AnyObject?
        
        
        if let plist = Plist(name: plistFileName) {
            
            let dict = plist.getMutablePlistFile()!
            
            let keys = Array(dict.allKeys)
            //print("[PlistManager] Keys are: \(keys)")
            
            if keys.count != 0 {
                
                for (_,element) in keys.enumerate() {
                    //print("[PlistManager] Key Index - \(index) = \(element)")
                    if element as! String == key {
                        print("[PlistManager] Found the Item that we were looking for for key: [\(key)]")
                        value = dict[key]!
                    } else {
                        //print("[PlistManager] This is Item with key '\(element)' and not the Item that we are looking for with key: \(key)")
                    }
                }
                
                if value != nil {
                    //print("[PlistManager] The Element that we were looking for exists: [\(key)]: \(value)")
                    return value!
                } else {
                    print("[PlistManager] WARNING: The Item for key '\(key)' does not exist! Please, check your spelling.")
                    return .None
                }
                
            } else {
                print("[PlistManager] No Plist Item Found when searching for item with key: \(key). The Plist is Empty!")
                return .None
            }
            
        } else {
            print("[PlistManager] Unable to get Plist")
            return .None
        }
        
    }
    
}