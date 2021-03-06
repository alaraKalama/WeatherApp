//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, DownloadManagerDelegate {
    
    let offsetSpeed: CGFloat = 25.0
    
    @IBOutlet weak var backgroundScrollview: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PlacesViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    var locationManager = CLLocationManager()
    let downloadManager = DownloadManager.sharedInstance
    let plistManager = PlistManager.sharedInstance
    
    var downloadQueue: NSOperationQueue = NSOperationQueue()
    
    var backgroundImageData: NSData?
    var places = [Place]()
    
    //do a [string:anyobject] data object, take its value from the delegate, than parse the json in the static place func
    var currentLocation: CLLocation!
    var locationData: [String : AnyObject]?
    var preventAnimation = Set<NSIndexPath>()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methods 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLocationManager()
        self.downloadManager.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.populateTableView()
        self.tableView.addSubview(self.refreshControl)
        if self.backgroundImageData?.bytes != nil {
            self.backgroundImage.image = UIImage(data: self.backgroundImageData!)
        } else {
            NSLog("problem")
        }
        //self.downloadManager.downloadImage(Constants.githubUrl + Constants.tablebackground, view: self.backgroundImage)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailReport"
        {
            if let cell = sender as? PlaceTableViewCell {
                let indexPath = self.tableView.indexPathForCell(cell)!
                assert(segue.destinationViewController.isKindOfClass(DetailedReportViewController))
                let detailViewController = segue.destinationViewController as! DetailedReportViewController
                detailViewController.place = self.places[indexPath.row]
            }
        }
    }
    
    // MARK: - Fetch data
    
    func populateTableView() {
        if places.count <= 0 {
            self.places = plistManager.getAllPlaces()
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.textCellIdentifier, forIndexPath: indexPath) as! PlaceTableViewCell
        let customSelectedColor = UIView()
        customSelectedColor.backgroundColor = UIColor.lightTextColor()
        cell.selectedBackgroundView = customSelectedColor
        let row = indexPath.row
        let place = places[row]
        PlaceTableViewCell.createFromPLace(place, cell: cell)

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
        self.locationManager.startMonitoringVisits()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if newLocation.coordinate.latitude != oldLocation.coordinate.latitude ||
                newLocation.coordinate.longitude != oldLocation.coordinate.longitude {
                self.currentLocation = newLocation
                let place = Place()
                place.latitude = "\(self.currentLocation.coordinate.latitude)"
                place.longitude = "\(self.currentLocation.coordinate.longitude)"
                
                self.reverseGeolocodeCurrentLocation(self.currentLocation, place: place, completion: { 
                    
                    for (index, place) in self.places.enumerate() {
                        if place.isCurrentLocation == true {
                            place.isCurrentLocation = false
                            self.places.removeAtIndex(index)
                        }
                    }
                    self.places.insert(place, atIndex: 0)
                    self.populateTableView()
                })
            }
        })
    }
    
    func reverseGeolocodeCurrentLocation(location: CLLocation, place: Place, completion: () -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(stuff, error) -> Void in
            if (error != nil) {
                NSLog("reverse geocode fail")
                completion()
                return
            }
            if stuff?.count > 0 {
                let placemark = CLPlacemark(placemark: stuff![0] as CLPlacemark)
                place.name = placemark.addressDictionary?[Constants.City] as? String
                place.isCurrentLocation = true
            } else {
                NSLog("No placemark!")
            }
            
            completion()
        })
    }
    
    // MARK: - Download Manager Delegate
    
    func didFetchDataForAllPlaces(sender: DownloadManager) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView?.reloadData()
            self.refreshControl.endRefreshing()
            self.downloadManager.downloadPlacesBackgroundImages(self.places)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func changeUnits(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            GlobalUnit.sharedManager.isCelsiusSystem = true
        } else if sender.selectedSegmentIndex == 1 {
            GlobalUnit.sharedManager.isCelsiusSystem = false
        }
        self.tableView?.reloadData()
    }
    
    // MARK: - UI Events
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSLog("scrollin")
        let offsetY = (scrollView.contentOffset.y - self.backgroundImage.frame.origin.y) / self.backgroundImage.frame.height * self.offsetSpeed
        let point = CGPoint(x: 0, y: offsetY)
        self.backgroundScrollview.setContentOffset(point, animated: true)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.populateTableView()
    }
}

