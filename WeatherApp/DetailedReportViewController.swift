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
        self.place.addObserver(self, forKeyPath: "backgroundImageData", options: .New, context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.place.removeObserver(self, forKeyPath: "backgroundImageData")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object != nil && object as? Place == self.place && keyPath != nil && keyPath! == "backgroundImageData" {
            if self.place.backgroundImageData.bytes != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.backgroundImage.alpha = 0
                    UIView.animateWithDuration(0.5, animations: {
                        self.backgroundImage.image = UIImage(data: self.place.backgroundImageData)
                        self.backgroundImage.alpha = 1
                    })
                })
            }
        }
    }
        
    // MARK: - UI Events
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //TODO: This func should be exported in one place
        let offsetY = (scrollView.contentOffset.y - self.backgroundImage.frame.origin.y) / scrollView.frame.height * self.offsetSpeed
        let point = CGPoint(x: 0, y: offsetY)
        self.backgroundScrollview.setContentOffset(point, animated: true)
    }
}
