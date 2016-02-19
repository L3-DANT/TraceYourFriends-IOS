//
//  ViewController.swift
//  TraceYourFriends-IOS
//
//  Created by Aniss on 16/02/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(animated: Bool) {
        let isUserLogIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        
        if (!isUserLogIn){
            self.performSegueWithIdentifier("LogInView", sender: self)
        }
    }
    
    @IBAction func logOutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.performSegueWithIdentifier("LogInView", sender: self)
    }
}

