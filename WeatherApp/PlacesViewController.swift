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
    var data: Dictionary<String, Dictionary<String, String>> = [
        "London" : [
            "temperature":"23",
            "time":"10:54"
        ],
        "Paris" : [
            "temperature":"28",
            "time":"11:54"
        ],
        "Sofia" : [
            "temperature":"29",
            "time":"12:54"
        ],
        
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        
        //let row = indexPath.row
        NSLog("tabbed on cell")
    }
    
    // MARK: - parsing my data
    //REMOVE!
    func getInfo(data: Dictionary<String, String>) -> (String) {
        return ""
    }
}

