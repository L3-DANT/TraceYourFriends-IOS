//
//  TabBarController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 07/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var isUserLogIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let traceController = self.viewControllers?[0] as? TraceController
        let detailController = self.viewControllers?[1] as? DetailViewController
        let optionsController = self.viewControllers?[2] as? OptionController
        optionsController?.delegate = traceController
        detailController?.delegate = traceController
        
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
