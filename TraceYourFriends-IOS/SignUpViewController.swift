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
        
        //Check if email is correct
        if (!isValidEmail(userEmail!)){
            displayErrorMessage("Please, enter a correct email")
        }
        
        //Check if password is correct
        if (userPassword?.characters.count < 6){
            displayErrorMessage("Please, enter more than 6 characters for the password")
        }
        
        //Check if password contains number
        
        let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
        
        let decimalRange = userPassword?.rangeOfCharacterFromSet(decimalCharacters, options: NSStringCompareOptions(), range: nil)
        
        if (decimalRange == nil) {
            displayErrorMessage("Please, enter at least 1 number")
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
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

}
