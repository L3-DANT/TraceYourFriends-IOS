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
        
        let userName:String! = userNameTextField.text
        let userEmail:String! = userEmailTextField.text
        let userPassword:String! = userPasswordTextField.text
        let userPasswordConf:String! = userPasswordConfTextField.text
        
        //Check the empty fields
        if userName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userPasswordConf!.isEmpty{
            
            //Error Message
            displayErrorMessage("All fields are required !")
            return
            
        }
        
        //Check password math
        if(userPassword != userPasswordConf){
            //Error Message
            displayErrorMessage("Password don't match !")
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
        
        
                            //======== Send user data to server side ========//
        
        //create the url with NSURL
        let myUrl = NSURL(string: "http://localhost:8080/TraceYourFriend/api/users/signup")
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(URL:myUrl!)
        
        //create the session object
        let session = NSURLSession.sharedSession()
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let jsonString : NSString =  "name=\(userName)&email=\(userEmail)&password=\(userPassword)"
        
        //set http method as POST
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // pass dictionary to nsdata object and set it as request body
        do {
            let param = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(param!, options: [])
        } catch {
            print(error)
            request.HTTPBody = nil
        }
        
        
                            //======== Create task & Execute it ========//
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            guard error == nil
                else
            {
                return
            }
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            let json: NSDictionary?
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            } catch let dataError {
                print(dataError)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                return
            }
            
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'status' out of it
                let resultValue = parseJSON["status"] as? String
                print("result: \(resultValue)")
                
                //Check if parsedJson value is Succes, if so then login is successfully done
                var isUserRegistrated:Bool = false;
                if(resultValue=="Success") { isUserRegistrated = true; }
                
                var messageToDisplay:String = parseJSON["message"] as! String!;
                if(!isUserRegistrated)
                {
                    messageToDisplay = parseJSON["message"] as! String!;
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //Display alert message with confirmation
                    let myAlert = UIAlertController(title:"Alert", message:messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.Default){ action in
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }
                    
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated: true, completion: nil);
                });
            }
            else {
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: \(jsonStr)")
            }
            
        })
        
        task.resume()
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
