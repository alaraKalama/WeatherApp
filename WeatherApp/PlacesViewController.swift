//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, DownloadManagerDelegate {
    
    let textCellIdentifier = "placeCell"
    
    var locationManager = CLLocationManager()
    let downloadManager = DownloadManager.sharedInstance
    let plistManager = PlistManager.sharedInstance
    
    var data : Dictionary<String, Dictionary<String, String>>!
    var places = [Place]()
    
    //do a [string:anyobject] data object, take its value from the delegate, than parse the json in the static place func
    var currentLocation: CLLocation!
    var locationData: [String : AnyObject]?

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methods 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLocationManager()
        self.downloadManager.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.populateTableView()
    }
    
    // MARK: - Fetch data
    
    func populateTableView() {
        self.places = plistManager.getAllPlaces()
        self.downloadManager.fetchDataForPlaces(places)
    }
    
        // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! PlaceTableViewCell
        
        let row = indexPath.row
        //let key = Array(data.keys)[row]
        if let name = places[row].name {
            cell.placeLabel.text = name
        }
        return cell
    }
    
    //MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Location Manager Delegate
    
    func startLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        //self.locationManager.stopUpdatingHeading()
        self.locationManager.startMonitoringVisits()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if newLocation.coordinate.latitude != oldLocation.coordinate.latitude ||
                newLocation.coordinate.longitude != oldLocation.coordinate.longitude {
                self.currentLocation = newLocation
                let place = Place()
                place.latitude = "\(self.currentLocation.coordinate.latitude)"
                place.longitute = "\(self.currentLocation.coordinate.longitude)"
                self.reverseGeolocodeCurrentLocation(self.currentLocation, place: place)
                for (index, place) in self.places.enumerate() {
                    if place.isCurrentLocation == true {
                        place.isCurrentLocation = false
                        self.places.removeAtIndex(index)
                    }
                }
                self.places.insert(place, atIndex: 0)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
            })
        })
    }
    
    func reverseGeolocodeCurrentLocation(location: CLLocation, place: Place) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(stuff, error) -> Void in
            if (error != nil) {
                NSLog("reverse geocode fail")
                return
            }
            if stuff?.count > 0 {
                let placemark = CLPlacemark(placemark: stuff![0] as CLPlacemark)
                place.name = placemark.addressDictionary?["City"] as? String
                place.isCurrentLocation = true
            } else {
                NSLog("No placemark!")
                return
            }
        })
    }
    
    // MARK: - Download Manager Delegate
    
    func didFetchLocationForecastData(sender: DownloadManager) {
        self.locationData = sender.locationData
        // fetch json
        print("didFetchLocationForecastData was called")
    }

}

