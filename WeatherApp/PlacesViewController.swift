//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let textCellIdentifier = "placeCell"
    
    let downloadManager = DownloadManager.sharedInstance
    
    let plistManager = PlistManager.sharedInstance
    
    var data : Dictionary<String, Dictionary<String, String>>!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

