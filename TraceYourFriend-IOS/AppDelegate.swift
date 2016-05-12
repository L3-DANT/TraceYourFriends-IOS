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
        core.requestWhenInUseAuthorization()
        
        UISearchBar.appearance().barTintColor = UIColor.whiteColor()
        UISearchBar.appearance().tintColor = UIColor.candyGreen()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyGreen()
        UITabBar.appearance().tintColor = UIColor.candyGreen()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        return true
    }
    
}

extension UIColor {
    static func candyGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
}

