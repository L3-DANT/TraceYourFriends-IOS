 //
//  AppDelegate.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    let core = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        if b{
            core.requestWhenInUseAuthorization()
        }
        
        UISearchBar.appearance().barTintColor = UIColor.whiteColor()
        UISearchBar.appearance().tintColor = UIColor.candyBlue()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyBlue()
        UITabBar.appearance().tintColor = UIColor.candyBlue()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().barTintColor = UIColor.candyBlue()
        return true
    }
    
}

extension UIColor {
    static func candyBlue() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
}

