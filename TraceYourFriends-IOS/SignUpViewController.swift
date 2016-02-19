//
//  SignUpViewController.swift
//  TraceYourFriends-IOS
//
//  Created by Aniss on 16/02/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userPasswordConfTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        let userName:String? = userNameTextField.text
        let userEmail:String? = userEmailTextField.text
        let userPassword:String? = userPasswordTextField.text
        let userPasswordConf:String? = userPasswordConfTextField.text
        
        //Check the empty fields
        if userName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userPasswordConf!.isEmpty{
            
            //Error Message
            displayErrorMessage("All fields are required !")
            return;
            
        }
        
        //Check password math
        if(userPassword != userPasswordConf){
            //Error Message
            displayErrorMessage("Password don't match !")
            return;
        }
        
        //Store Data
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //Display confirmation message
        let myAlert = UIAlertController(title: "Alert", message:"Sign up successfully", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func displayErrorMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    
    }

}
