//
//  ViewController.swift
//  TouchExplore
//
//  Created by Raphael Grossenbacher on 18.03.20.
//  Copyright © 2020 ZHAW. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import AVFoundation
import CoreHaptics

class MenuViewController: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var storyBoard : UIStoryboard!
    var presenter : ViewController!
    @IBOutlet weak var AdressSuche: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = self.presentingViewController as! ViewController
    }

    @IBAction func dismissMenu(_ sender: Any) {
        presenter.centerGPS()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playInstructions(_ sender: Any) {
        presenter.playInstructions()
    }
    @IBAction func closeMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
