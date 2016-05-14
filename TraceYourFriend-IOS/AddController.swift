//
//  AddController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 14/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class AddController: UITableViewController {
    
    var contacts: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func inviteContact(sender: AnyObject) {
        
       let indexPath = tableView.indexPathForSelectedRow
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/invite"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["inviteName": contacts[indexPath!.row]]
        
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
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/search/contact"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["search": searchText]
        
        
        
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
                
                
                self.contacts = postString.characters.split{$0 == ","}.map(String.init)
                for i in 0...self.contacts.count-1 {
                    self.contacts[i] = self.contacts[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    self.contacts[i] = self.contacts[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    self.contacts[i] = self.contacts[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                
                self.performSelectorOnMainThread(#selector(SigninViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
            
        }).resume()

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.contacts[indexPath.row]
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
