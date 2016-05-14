//
//  DetailViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//



import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let detailDescriptionLabel = detailDescriptionLabel {
                detailDescriptionLabel.text = "Voulez vous accepter " + detailUser.name + "?"
                title = detailUser.name
                
            }
        }
    }
    
    @IBAction func acceptRequest(sender: AnyObject) {
        sendJson((detailUser!.name), bool: true)
        let user = Amis.getInstance.userFromName((detailUser?.name)! as String)
        print((user?.name)! as String)
        user!.category = "Friends"
        viewDidLoad()
        
    }
    
    @IBAction func declineRequest(sender: AnyObject) {
        sendJson((detailUser!.name), bool: false)
        
        let contactViewController:ContactViewController = ContactViewController()
        
        self.presentViewController(contactViewController, animated: true, completion: nil)
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
                    
                    print("ERROR")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                self.performSelectorOnMainThread(#selector(SigninViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
    }
    
}

