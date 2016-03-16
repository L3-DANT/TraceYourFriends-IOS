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
        let userEmail:String! = userEmailTextField.text
        let userPassword:String! = userPasswordTextField.text
        
        if((userEmail!.isEmpty) || (userPassword!.isEmpty)){
            displayErrorMessage("User email or password are empty !")
            return
        }
        

                            //======== Send user data to server side ========//
        
        //create the url with NSURL
        let myUrl = NSURL(string: "http://localhost:8080/TraceYourFriend/api/LogIn")
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(URL:myUrl!)
        
        //create the session object
        let session = NSURLSession.sharedSession()
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let jsonString : NSString =  "email=\(userEmail)&password=\(userPassword)"
        
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
                
                if (resultValue == "Succes"){
                    
                    //Then LogIn is successfully done
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
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


}
