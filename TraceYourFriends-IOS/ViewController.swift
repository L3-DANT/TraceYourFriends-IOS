//
//  ViewController.swift
//  TraceYourFriends-IOS
//
//  Created by Aniss on 16/02/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.setUserTrackingMode(.Follow, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        /*let isUserLogIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        
        if (!isUserLogIn){
        self.performSegueWithIdentifier("LogInView", sender: self)
        }*/
    }
    
    
    
    
    /*@IBAction func logOutButtonTapped(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogIn")
    NSUserDefaults.standardUserDefaults().synchronize()
    
    self.performSegueWithIdentifier("LogInView", sender: self)
    }*/
}

