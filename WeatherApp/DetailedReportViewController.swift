//
//  DetailedReportViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 6/30/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class DetailedReportViewController: UIViewController, UIScrollViewDelegate {

    let downloadManager = DownloadManager.sharedInstance

    private var lastContentOffset: CGFloat = 0
    var place: Place!
    @IBOutlet var detailsView: DetailsView!
    @IBOutlet weak var backgroundScrollview: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = place.name
        self.fetchBackgroundPhoto()
        self.detailsView.displayPlaceInfo(self.place)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchBackgroundPhoto() {
        var backgroundURL = String()
        switch place.icon {
        case Constants.clear_day?:
            backgroundURL = Constants.cleardayUrl
        case Constants.clear_night?:
            backgroundURL = Constants.clearnightUrl
        case Constants.cloudy_day?:
            backgroundURL = Constants.cloudydayUrl
        case Constants.cloudy_night?:
            backgroundURL = Constants.cloudynightUrl
        case Constants.partly_cloudy_day?:
            backgroundURL = Constants.partlycloudydayUrl
        case Constants.partly_cloudy_night?:
            backgroundURL = Constants.cloudynightUrl
        case Constants.rain?:
            backgroundURL = Constants.raindayUrl
        case Constants.sleet?:
            backgroundURL = Constants.sleetUrl
        case Constants.snow?:
            backgroundURL = Constants.snowdayUrl
        case Constants.fog?:
            backgroundURL = Constants.fogUrl
        default:
            backgroundURL = Constants.cleardayUrl
        }
        
        downloadManager.downloadImage(Constants.githubUrl + backgroundURL, view: self.backgroundImage)
    }
    
    
    // MARK: - UI Events
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("they see me scrollin")
        self.lastContentOffset = scrollView.contentOffset.y
        let point = CGPoint(x: 0, y: self.lastContentOffset)
        self.backgroundScrollview.setContentOffset(point, animated: true)
    }

}
