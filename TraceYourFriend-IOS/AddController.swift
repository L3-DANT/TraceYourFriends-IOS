//
//  AddController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 14/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class AddController: UITableViewController {
    
    var filteredUser = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    var users = [User]()
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUser = users.filter { user in
            return user.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUser.count
        }
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellUser", forIndexPath: indexPath)
        let user: User
        if searchController.active && searchController.searchBar.text != "" {
            user = filteredUser[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.category
        return cell
        

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Request
        let indexPath = tableView.indexPathForSelectedRow
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/invite"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let nameAmi = users[indexPath!.row].name
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
                    
                    print("ERROR")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                
                if(postString == "200"){
                    self.message("L'envoie d'invitation s'est effectué avec succes")
                }
                
            
                self.performSelectorOnMainThread(#selector(AddController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
        
    }
   func searchBarUsers(searchText: String) {
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/search/contact"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["mail": searchText]
        
        
        
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
                
                print("le POST recherche: " + postString)
                var u :User
                self.users.removeAll()
                var poeple = postString.characters.split{$0 == ","}.map(String.init)
                for i in 0...poeple.count-1 {
                    poeple[i] = poeple[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    poeple[i] = poeple[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    poeple[i] = poeple[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    u = User(name: poeple[i], category: "", coorX: 0.0, coorY: 0.0  )
                    self.users.append(u)
                }
                self.performSelectorOnMainThread(#selector(AddController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
            
        }).resume()

    }
    
    func updatePostLabel(string: String) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func message(userMessage:String){
        
        dispatch_async(dispatch_get_main_queue(), {
            let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
        })
    }

}

extension AddController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var str : String
        str = searchController.searchBar.text!
        if str.characters.count > 1 {
            filterContentForSearchText(str)
            searchBarUsers(str)
        }else{
            self.users.removeAll()
        }
        tableView.reloadData()
    }
}
