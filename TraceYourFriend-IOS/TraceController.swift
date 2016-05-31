//
//  TraceController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit
import PusherSwift

class TraceController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, OptionControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapKit: MKMapView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var pusher : Pusher!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        pusher = Pusher(
            key:"e19d3311d6540da19604"
        )
        
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        let channel = self.pusher.subscribe(name)
        let ami: Amis = Amis.getInstance
        
        channel.bind("coorX/coorY", callback: { (data: AnyObject?) -> Void in
            let datas = String(data)
            var coor = datas.characters.split{$0 == "/"}.map(String.init)
            var bin = coor[0].characters.split{$0 == "\""}.map(String.init)
            let name = bin[1]
            let coorY = coor[2].characters.split{$0 == "\""}.map(String.init)[0]
            for i in 0...ami.ami.count-1{
                if ami.ami[i].name == name{
                    ami.ami[i].coorX = Double(coor[1])!
                    ami.ami[i].coorY = Double(coorY)!
                    self.showFriends()
                }
            }
        })
        self.pusher.connect()
        
        mapKit.setUserTrackingMode(.Follow, animated: true)
        mapKit.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        showFriends()
        
        dispatch_async(dispatch_get_main_queue(), {
            let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")

            if(b){
                 NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: #selector(TraceController.updateCoor), userInfo: nil, repeats: true)
            }
        })
        
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        if (b) {
            let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
            sendJsonFriend(name)
            dispatch_async(dispatch_get_main_queue(), {
                NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(TraceController.sendJsonWN), userInfo: nil, repeats: true)
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        for ami in Amis.getInstance.ami {
            if searchText == ami.name {
                centerOnFriend1(ami)
            }
        }
    }
    
    func sendJsonWN(){
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        
        if(b){
            sendJsonFriend(name)
        }
    }

    
    
    func centerOnFriend1(user: User) {
        let userLocation: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: user.coorX, longitude: user.coorY)
        centerMapOnLocation(userLocation)

    }
    
    func changeMapDisplayMode() {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapKit.mapType = .Standard
        }
        
        let satelliteMapTypeAction = UIAlertAction(title: "Satellite", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapKit.mapType = .Satellite
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapKit.mapType = .Hybrid
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(satelliteMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func changeTypeDisplayMode() {
        let actionSheet = UIAlertController(title: "Travel Mode", message: "Select travel mode:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let drivingModeAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.travelMode = TravelModes.driving
            //self.recreateRoute()
        }
        
        let walkingModeAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.travelMode = TravelModes.walking
            //self.recreateRoute()
        }
        
        let bicyclingModeAction = UIAlertAction(title: "Bicycling", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.travelMode = TravelModes.bicycling
            //self.recreateRoute()
        }
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(drivingModeAction)
        actionSheet.addAction(walkingModeAction)
        actionSheet.addAction(bicyclingModeAction)
        actionSheet.addAction(closeAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showFriends(){
        
        for ami in Amis.getInstance.ami {
            let friendLocation = CLLocationCoordinate2DMake(ami.coorX, ami.coorY)
            let dropPin = ami.dropPin
            dropPin.coordinate = friendLocation
            dropPin.title = ami.name
            dropPin.subtitle = ami.category
            mapView(mapKit, viewForAnnotation: dropPin)!.annotation = dropPin
            if !(ami.coorX == 0.0 && ami.coorY == 0.0) {
                mapKit.addAnnotation(dropPin)
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "friendMap")
            annotationView!.rightCalloutAccessoryView = detailButton
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }

    @IBAction func findMe(sender: AnyObject) {
        mapKit.setUserTrackingMode(.Follow, animated: true)
    }
    
    
    func updateCoor() {
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        if b {
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
                sendJson(name, coorX: location.coordinate.latitude as Double, coorY: location.coordinate.longitude as Double)
            }else{
                sendJson(name, coorX: 0.0, coorY: 0.0)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        updateCoor()
    }
    
    
    func sendJson(name: String, coorX: Double, coorY: Double){
        
        
        let postEndpoint: String = "http://134.157.123.196:8080/TraceYourFriends/api/users/coord"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["name": name, "coorX": coorX, "coorY": coorY]
        
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
            
            
        } catch {
            
            print("ERROR : TraceController")
            
        }
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    
                    print("ERROR2 : TraceController")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                //print("le POST trace :" + postString)
                
                if (postString == "[]"){
                    
                }else{
                    var request = postString.characters.split{$0 == ","}.map(String.init)
                    let ami : Amis = Amis.getInstance
                    var user :User
                    for i in 0...request.count-1 {
                        request[i] = request[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        request[i] = request[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        request[i] = request[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    }
                    ami.deleteAll(request, str: "Request")
                    for i in 0...request.count-1 {
                        var bool : Bool = true
                        for t in ami.request{
                            if(t.name == request[i]){
                                bool = false
                            }
                        }
                        if (bool){
                            user = User(name: request[i], category: "Request", coorX: 0, coorY: 0)
                            ami.add(user, str: "Request")
                        }
                    }

                }
                self.performSelectorOnMainThread(#selector(TraceController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
        }).resume()
        
    }
    
    func sendJsonFriend(name : String){
        //Envoi les données de log in
        
        let postEndpoint: String = "http://134.157.123.196:8080/TraceYourFriends/api/users/listFriend"
        
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
                    let ami : Amis = Amis.getInstance
                    var user :User
                    for i in 0...friends.count-1 {
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        friends[i] = friends[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    }
                    let list = ami.deleteAll(friends, str: "Friends")
                    if (!list.isEmpty){
                        for i in 0...list.count-1{
                            self.mapKit.removeAnnotation(list[i].dropPin)
                        }
                    }
                    for i in 0...friends.count-1 {
                        var bool : Bool = true
                        for t in ami.ami{
                            if(t.name == friends[i]){
                                bool = false
                            }
                        }
                        if (bool){
                            if (i != 0){
                                user = User(name: friends[i], category: "Friends", coorX: 0, coorY: 0)
                                ami.add(user, str: "Friends")
                            }
                        }
                    }
                    
                }
                self.performSelectorOnMainThread(#selector(TraceController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
        
    }
    func updatePostLabel(postString: String) {
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        if b {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        mapKit.setRegion(coordinateRegion, animated: true)
    }
}


