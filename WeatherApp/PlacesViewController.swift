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
        self.data = downloadManager.getData()
    }
    
    
        // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! PlaceTableViewCell
        
        let row = indexPath.row
        let key = Array(data.keys)[row]
        cell.placeLabel.text = key
        
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
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if newLocation.coordinate.latitude != oldLocation.coordinate.latitude ||
            newLocation.coordinate.longitude != oldLocation.coordinate.longitude {
            self.currentLocation = newLocation
            let myPLace = Place()
            myPLace.latitude = "\(currentLocation.coordinate.latitude)"
            myPLace.longitute = "\(currentLocation.coordinate.longitude)"
            self.downloadManager.getDataForLocation(currentLocation)
        } else {
            self.currentLocation = oldLocation
        }
        
    }
    
    // MARK: - Download Manager Delegate
    
    func didFetchLocationForecastData(sender: DownloadManager) {
        self.locationData = sender.locationData
        // fetch json
        print("didFetchLocationForecastData was called")
    }

}

