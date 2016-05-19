//
//  OptionController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 07/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit



enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}
class OptionController: UIViewController {

    var travelMode = TravelModes.driving
    
    var mapOption = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    @IBAction func changeTravelMode(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Travel Mode", message: "Select travel mode:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let drivingModeAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.travelMode = TravelModes.driving
            //self.recreateRoute()
        }
        
        let walkingModeAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.travelMode = TravelModes.walking
            //self.recreateRoute()
        }
        
        let bicyclingModeAction = UIAlertAction(title: "Bicycling", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.travelMode = TravelModes.bicycling
            //self.recreateRoute()
        }
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(drivingModeAction)
        actionSheet.addAction(walkingModeAction)
        actionSheet.addAction(bicyclingModeAction)
        actionSheet.addAction(closeAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)

    }
    @IBAction func changeMapType(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.viewMap.mapType = kGMSTypeNormal
            self.mapOption.mapType = .Standard
        }
        
        let satelliteMapTypeAction = UIAlertAction(title: "Satellite", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.viewMap.mapType = kGMSTypeTerrain
            self.mapOption.mapType = .Satellite
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapOption.mapType = .Hybrid
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(satelliteMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
}
