//
//  SigninViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 13/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameTextBox: UITextField!

    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    @IBOutlet weak var confirmPasswordTextBox: UITextField!
    
    @IBAction func SignupTapped(sender: AnyObject) {
        
        let userName:String! = nameTextBox.text
        let userEmail:String! = emailTextBox.text
        let userPassword:String! = passwordTextBox.text
        let userPasswordConf:String! = confirmPasswordTextBox.text
        
        
        //Check the empty fields
        if userName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userPasswordConf!.isEmpty{
            
            //Error Message
            displayErrorMessage("All fields are required !")
            return
        }
        
        //Check password math
        if(userPassword != userPasswordConf){
            //Error Message
            displayErrorMessage("Passwords don't match !")
            return
        }
        
        //Check if email is correct
        if (!isValidEmail(userEmail!)){
            displayErrorMessage("Please, enter a correct email")
            return
        }
        
        //Check if password is correct
        if (userPassword?.characters.count < 6){
            displayErrorMessage("Please, enter more than 6 characters for the password")
            return
        }
        
        //Check if password contains number
        let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
        
        let decimalRange = userPassword?.rangeOfCharacterFromSet(decimalCharacters, options: NSStringCompareOptions(), range: nil)
        
        if (decimalRange == nil) {
            displayErrorMessage("Please, enter at least one number")
            return
        }
        
        
        
        //Envoi des informations d'enregistrement au serveur
        
        
        let postEndpoint: String = "https://localhost/users/inscription/"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["name": userName, "email": userEmail,"password":userPassword]
        
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
            
            
        } catch {
            
            print("ERROR")
            
        }
        
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    
                    print("ERROR")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
        
        
        
    }
    
    func displayErrorMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }


}
