//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
    
    let textCellIdentifier = "placeCell"
    
    var locationManager = CLLocationManager()
    let downloadManager = DownloadManager.sharedInstance
    let plistManager = PlistManager.sharedInstance
    
    var data : Dictionary<String, Dictionary<String, String>>!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.populateTableView()
    }
    
    // MARK: - Fetch data
    func populateTableView() {
        let places = plistManager.getAllPlaces()
        downloadManager.fetchDataForPlaces(places)
        data = downloadManager.getData()
    }
    
    // MARK: - Location functions
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print(newLocation.coordinate.latitude)
        print(newLocation.coordinate.longitude)
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
}

