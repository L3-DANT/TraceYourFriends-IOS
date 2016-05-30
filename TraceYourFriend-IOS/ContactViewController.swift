//
//  ContactViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 11/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {
    
    var filteredUsers = [User]()
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        users = Amis.getInstance.ami + Amis.getInstance.request
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Favorite", "Friends", "Request"]
        searchController.searchBar.delegate = self
        
        filterContentForSearchText("")
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { user in
            let categoryMatch = (scope == "All") || (user.category == scope)
            return  categoryMatch && (user.name.lowercaseString.containsString(searchText.lowercaseString) || searchText == "")
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        super.viewWillAppear(animated)
        users = Amis.getInstance.ami + Amis.getInstance.request
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active{
            return filteredUsers.count
        }
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let user: User
        if searchController.active{
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.category
        return cell
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDetailView"){
            let detailNC: UINavigationController = (segue.destinationViewController as? UINavigationController)!
            let detailVC: DetailViewController? = detailNC.topViewController as! DetailViewController?
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let user: User
                if searchController.active{
                    user = filteredUsers[indexPath.row]
                } else {
                    user = users[indexPath.row]
                }
                detailVC!.detailUser = user
                detailVC!.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                detailVC!.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 
}
extension ContactViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
extension ContactViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])

    }
}
