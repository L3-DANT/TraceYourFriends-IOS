//
//  LoginViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 13/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    
    @IBAction func LoginClicked(sender: AnyObject) {
        
        let userEmail:String! = emailTextBox.text
        let userPassword:String! = passwordTextBox.text
        
        if((userEmail!.isEmpty) || (userPassword!.isEmpty)){
            displayErrorMessage("User email or password are empty !")
            return
        }
    
    }
    
    
    
    
    
    func displayErrorMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }

}
