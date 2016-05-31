//
//  TraceController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit

class TraceController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, OptionControllerDelegate, ContactViewControllerDelegate {
    
    @IBOutlet weak var mapKit: MKMapView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = friendLocation
            dropPin.title = ami.name
            dropPin.subtitle = ami.category
            mapView(mapKit, viewForAnnotation: dropPin)!.annotation = dropPin
            mapKit.addAnnotation(dropPin)
            
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
        
        
        let postEndpoint: String = "http://localhost:8080/TraceYourFriends/api/users/coord"
        
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
                
                print("le POST trace :" + postString)
                
                if (postString == "[]"){
                    
                }else{
                    var request = postString.characters.split{$0 == ","}.map(String.init)
                    let ami : Amis = Amis.getInstance
                    var user :User
                    ami.deleteAll("Request")
                    for i in 0...request.count-1 {
                        request[i] = request[i].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        request[i] = request[i].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        request[i] = request[i].stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        user = User(name: request[i], category: "Request", coorX: 0, coorY: 0)
                        ami.add(user, str: "Request")
                    }
                }
                self.performSelectorOnMainThread(#selector(TraceController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
            }
        }).resume()
        
    }
    
    func updatePostLabel(str : String)  {
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



