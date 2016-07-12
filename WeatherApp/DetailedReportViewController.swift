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

    let offsetSpeed: CGFloat = 25.0
    
    private var lastContentOffset: CGFloat = 0
    var place: Place!
    @IBOutlet var detailsView: DetailsView!
    @IBOutlet weak var backgroundScrollview: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = place.name
        if place.backgroundImageData.bytes != nil{
            self.backgroundImage.image = UIImage(data: place.backgroundImageData)
        }
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.detailsView.displayPlaceInfo(self.place)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI Events
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //TODO: This func should be exported in one place
        let offsetY = (scrollView.contentOffset.y - self.backgroundImage.frame.origin.y) / scrollView.frame.height * self.offsetSpeed
        let point = CGPoint(x: 0, y: offsetY)
        self.backgroundScrollview.setContentOffset(point, animated: true)
    }
    

}
