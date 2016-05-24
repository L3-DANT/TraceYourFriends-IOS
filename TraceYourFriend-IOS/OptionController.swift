//
//  OptionController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 07/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit


protocol OptionControllerDelegate : NSObjectProtocol {
    func changeMapDisplayMode()
    func changeTypeDisplayMode()
    //func disableLocation(sender: UIButton)
    //func enableLocation(sender: UIButton)
}
class OptionController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    var mapOption = MKMapView()
    
    @IBOutlet weak var permitButton: UIButton!
    
    @IBOutlet weak var travelButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    
    weak var delegate : OptionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        permitButton.backgroundColor = UIColor.candyBlue()
        permitButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        travelButton.backgroundColor = UIColor.candyBlue()
        travelButton.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        mapButton.backgroundColor = UIColor.candyBlue()
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

    @IBAction func disablePermissionLocation(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    @IBAction func changeTravelMode(sender: AnyObject) {
        self.delegate?.changeTypeDisplayMode()
    }
    @IBAction func changeMapType(sender: AnyObject) {
        self.delegate?.changeMapDisplayMode()
        
    }
    override func viewWillAppear(animated: Bool) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
            permitButton.setTitle("Disable permission location", forState: .Normal)
        }else{
            permitButton.setTitle("Enable permission location", forState: .Normal)
        }
    }
}
