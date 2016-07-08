//
//  DetailedReportViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class DetailedReportViewController: UIViewController {

    var place: Place!
    @IBOutlet var detailsView: DetailsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = place.name
        self.detailsView.displayPlaceInfo(self.place)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
