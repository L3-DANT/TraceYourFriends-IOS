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
        //Could not cast value of type 'TraceYourFriend_IOS.TabBarController' (0x10544b120) to'UISplitViewController' (0x1077ab240).
        //
        /*let splitViewController = window!.rootViewController as! UISplitViewController
        
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        */
        
        UISearchBar.appearance().barTintColor = UIColor.whiteColor()
        UISearchBar.appearance().tintColor = UIColor.candyGreen()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.candyGreen()
        UITabBar.appearance().tintColor = UIColor.candyGreen()
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
     guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
     guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
     if topAsDetailController.detailUser == nil {
     // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
     return true
     }
     return false
     }

    
}

extension UIColor {
    static func candyGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
}

