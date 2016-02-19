//
//  LogInViewController.swift
//  TraceYourFriends-IOS
//
//  Created by Aniss on 19/02/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButtonTapped(sender: AnyObject) {
        let userEmail:String? = userEmailTextField.text
        let userPassword:String? = userPasswordTextField.text
        
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        var userPassDontMatch = false
        
        if (userEmailStored == userEmail){
            if(userPasswordStored == userPassword){
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: nil)
                userPassDontMatch = true
            }
        }
        
        if (!userPassDontMatch){
            displayErrorMessage("Email or Password don't match")
        }
        
    }
    func displayErrorMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }


}
