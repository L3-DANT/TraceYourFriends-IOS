//
//  TabBarController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 07/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import PusherSwift

class TabBarController: UITabBarController {
    
    var isUserLogIn = false
    var pusher : Pusher!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pusher = Pusher(
            key:"37c3b876be2d4696857a",
            options: ["cluster": "eu"]
        )

        // Do any additional setup after loading the view.
        let traceController = self.viewControllers?[0] as? TraceController
        let detailController = self.viewControllers?[1] as? DetailViewController
        let optionsController = self.viewControllers?[2] as? OptionController
        optionsController?.delegate = traceController
        detailController?.delegate = traceController
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        if (b) {
            let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
            sendJson(name)
            dispatch_async(dispatch_get_main_queue(), {
                NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: #selector(TabBarController.sendJsonWN), userInfo: nil, repeats: true)
            })
        }
        
    }
    func sendJsonWN(){
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        sendJson(name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isUserLogIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        
        if (!isUserLogIn){
            self.performSegueWithIdentifier("logInView", sender: self)
        }
    }
    
    func sendJson(name : String){
        //Envoi les données de log in
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/listFriend"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["mail": name]
        
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
            
            
        } catch {
            
            print("ERROR: TabBar Controller")
            
        }
        
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    
                    print("ERROR 2 : TabBar Controller")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                //print("le POST ami: " + postString)
                if (postString == "[]"){
                    
                }else{
                    var friends = postString.characters.split{$0 == ","}.map(String.init)
                    let ami: Amis = Amis.getInstance
                    var user :User
                    let channel = self.pusher.subscribe(friends[0])
                    ami.deleteAll("Friends")
                    for i in 0...friends.count-1 {
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        channel.bind("coorX/coorY", callback: { (data: AnyObject?) -> Void in
                            if let data = data as? String {
                                print(data)
                                
                                var coor = data.characters.split{$0 == "/"}.map(String.init)
                                for i in 0...ami.ami.count-1{
                                    print(channel.name)
                                    if ami.ami[i].name == coor[0]{
                                        ami.ami[i].coorX = Double(coor[1])!
                                        ami.ami[i].coorY = Double(coor[2])!
                                    }
                                }
                            }
                        })
                        if (i != 0){
                            user = User(name: friends[i], category: "Friends", coorX: 0, coorY: 0)
                            ami.add(user, str: "Friends")
                        }
                    }
                    self.pusher.connect()
                }
                self.performSelectorOnMainThread(#selector(TabBarController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
            
        }).resume()

    }
    func updatePostLabel(postString: String) {
        
    }
}
