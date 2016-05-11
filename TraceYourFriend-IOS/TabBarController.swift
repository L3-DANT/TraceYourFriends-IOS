//
//  TabBarController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 07/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {
    
    var isUserLogIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isUserLogIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        
        if (!isUserLogIn){
            self.performSegueWithIdentifier("logInView", sender: self)
        }
    }
}
