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
        
        //Envoi les données de log in
        
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/connexion"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["mail": userEmail,"password":userPassword]
        
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
            
            
        } catch {
            
            print("ERROR1")
            
        }
        
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    
                    print("ERROR")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                if(postString == "200"){
                    //Then LogIn is successfully done
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
                self.performSelectorOnMainThread(#selector(SigninViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
        
        
        
    }
    
    func updatePostLabel(postString: String) {
        
    }
    
    
    func displayErrorMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }

}
