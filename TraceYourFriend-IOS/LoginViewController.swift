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
        
        let userEmail:String! = emailTextBox.text
        let userPassword:String! = passwordTextBox.text
        
        if((userEmail!.isEmpty) || (userPassword!.isEmpty)){
            displayErrorMessage("User email or password are empty !")
            return
        }
        
        //Envoi les données de log in
        
        let postEndpoint: String = "http://134.157.123.196:8080/TraceYourFriends/api/users/connexion"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["mail": userEmail,"password":userPassword]
        
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
            
            
        } catch {
            
            print("ERROR: LoginViewController")
            
        }
        
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    
                    print("ERROR 2 : LoginView COntroller")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                if(postString != "[]"){
                    //Then LogIn is successfully done
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogIn")
                    NSUserDefaults.standardUserDefaults().setValue(userEmail, forKey: "myName")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    var friends = postString.characters.split{$0 == ","}.map(String.init)
                    let ami: Amis = Amis.getInstance
                    var user :User
                    ami.deleteAll([], str: "All")
                    for i in 0...friends.count-1 {
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        if (i != 0){
                            user = User(name: friends[i], category: "Friends", coorX: 0, coorY: 0)
                            ami.add(user, str: "Friends")
                        }else{
                            NSUserDefaults.standardUserDefaults().setValue(friends[0], forKey: "myName")
                        }
                    }
                }else{
                    self.displayErrorMessage("Wrong Login or Password")
                    return
                }
                self.performSelectorOnMainThread(#selector(LoginViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
        
        
        
    }
    
    func updatePostLabel(postString: String) {
        
    }
    
    
    func displayErrorMessage(userMessage:String){
        
        dispatch_async(dispatch_get_main_queue(), {
            let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
        })
    }

}
