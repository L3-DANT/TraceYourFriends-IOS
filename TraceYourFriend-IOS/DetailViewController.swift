//
//  DetailViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//



import UIKit
import MapKit

protocol DetailViewControllerDelegate : NSObjectProtocol {
    func centerOnFriend(user : User)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    var mapDetail = MKMapView()
    
    weak var delegate : DetailViewControllerDelegate?
    
    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let detailDescriptionLabel = detailDescriptionLabel {
                if detailUser.category == "Friends" {
                    detailDescriptionLabel.text = "Profile of : " + detailUser.name
                    title = detailUser.name
                    acceptButton.setTitle("Trace " + detailUser.name, forState: .Normal)
                    declineButton.setTitle("Remove " + detailUser.name, forState: .Normal)
                }else if detailUser.category == "Request"{
                    detailDescriptionLabel.text = "Would you like to accept : " + detailUser.name + " ?"
                    title = detailUser.name
                }else if detailUser.category == "Favorite"{
                    detailDescriptionLabel.text = "Profile of your favorite friend : " + detailUser.name
                    title = detailUser.name
                    acceptButton.setTitle("Trace " + detailUser.name, forState: .Normal)
                    declineButton.setTitle("Remove " + detailUser.name, forState: .Normal)
                }
            }
        }
    }
    
    
    //Accept request or trace if the user is already a friend or favorite
    @IBAction func acceptRequest(sender: AnyObject) {
        if detailUser?.category == "Request" {
            message("You just added as friend " + detailUser!.name)
            Amis.getInstance.request.removeAll()
            sendJson((detailUser!.name), bool: true)
            viewDidLoad()
        }else{
            self.delegate?.centerOnFriend(detailUser!)
        }
        
    }
    
    
    //Decline request or delete the user if he's already a friend or favorite
    @IBAction func declineRequest(sender: AnyObject) {
        if detailUser?.category == "Request" {
            message("You declined " + detailUser!.name)
            sendJson((detailUser!.name), bool: false)
            viewDidLoad()
        }else{
            message("You removed " + detailUser!.name)
            sendJsonDelete(detailUser!.name)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func sendJson(nameAmi: String, bool: Bool){
        //Envoi des informations d'enregistrement au serveur
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/request"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        let postParams : [String: AnyObject] = ["name": name, "nameAmi": nameAmi,"bool":bool]
        
        
        
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
                    
                    print("ERROR : DetailViewController")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                self.performSelectorOnMainThread(#selector(DetailViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
    }
    
    func updatePostLabel(str: String) {
    }
    
    func message(userMessage:String){
        
        dispatch_async(dispatch_get_main_queue(), {
            let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
        })
    }
    
    func sendJsonDelete(nameAmi: String){
        //Envoi des informations d'enregistrement au serveur
        
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/delete"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        let postParams : [String: AnyObject] = ["name": name, "nameAmi": nameAmi]
        
        
        
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
                    
                    print("ERROR : Detail View Controller2")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                self.performSelectorOnMainThread(#selector(DetailViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
    }
}

