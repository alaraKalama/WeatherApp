//
//  SplashAnimationViewController.swift
//  WeatherApp
//
//  Created by Bianca Hinova on 7/12/16.
//  Copyright © 2016 Bianca Hinova. All rights reserved.
//

import UIKit

class SplashAnimationViewController: UIViewController, DownloadManagerDelegate {

    var downloadManager = DownloadManager.sharedInstance
    
    var placesVC: PlacesViewController? = nil

    @IBOutlet weak var moonImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadManager.delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        placesVC = storyboard.instantiateViewControllerWithIdentifier("PlacesTable") as? PlacesViewController

        let animationImages: [UIImage] = [ UIImage(named: "moon1")!,
                                UIImage(named: "moon2")!,
                                UIImage(named: "moon3")!,
                                UIImage(named: "moon4")!,
                                UIImage(named: "moon5")!,
                                UIImage(named: "moon6")!,
                                UIImage(named: "moon7")!
        ]
        
        self.moonImageView.animationImages = animationImages
        self.moonImageView.animationDuration = 0.9
        self.moonImageView.startAnimating()
        self.downloadNeededAssets()
    }
    
    func downloadNeededAssets() {
        self.downloadManager.downloadTableVCBackgroundImage(Constants.githubUrl + Constants.tablebackground, tableVC: self.placesVC!)
    }
    
    func didDownloadBackgroundImage(sender: DownloadManager) {
        let navVC = UINavigationController(rootViewController: self.placesVC!)
        self.moonImageView.stopAnimating()
        self.presentViewController(navVC, animated: true, completion: nil)
    }
}
