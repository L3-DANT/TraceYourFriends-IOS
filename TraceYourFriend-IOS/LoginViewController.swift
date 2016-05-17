//
//  LoginViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 13/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import PusherSwift

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
        
        let pusher = Pusher(
            key:"37c3b876be2d4696857a",
            options: ["cluster": "eu"]
        )
        
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
                
                if(postString != "null"){
                    //Then LogIn is successfully done
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogIn")
                    NSUserDefaults.standardUserDefaults().setValue(userEmail, forKey: "myName")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    var friends = postString.characters.split{$0 == ","}.map(String.init)
                    
                    var channel = [PusherChannel]()
                    for i in 0...friends.count-1 {
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        channel.append(pusher.subscribe(friends[i]))
                        channel[i].bind("coor", callback: { (data: AnyObject?) -> Void in
                            if let data = data as? String {
                                Amis.getInstance.ami[i] = User(name: data, category: "",coorX: 0.0,coorY: 0.0)
                            }
                        })
                    }
                    pusher.connect()
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
