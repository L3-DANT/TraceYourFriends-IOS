//
//  TraceController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit

class TraceController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, OptionControllerDelegate {
    
    @IBOutlet weak var mapKit: MKMapView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var optionController = OptionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.setUserTrackingMode(.Follow, animated: true)
        mapKit.delegate = self
        optionController.delegate = self
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        showFriends()
        
        dispatch_async(dispatch_get_main_queue(), {
            NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: #selector(TraceController.updateCoor), userInfo: nil, repeats: true)
        })
    }
    
    func changeMapDisplayMode() {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.viewMap.mapType = kGMSTypeNormal
            self.mapKit.mapType = .Standard
        }
        
        let satelliteMapTypeAction = UIAlertAction(title: "Satellite", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.viewMap.mapType = kGMSTypeTerrain
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
        if b && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
            let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
            sendJson(name, coorX: location.coordinate.latitude, coorY: location.coordinate.longitude)
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
        
        let postParams : [String: AnyObject] = ["nameOrEmail": name, "coorX": coorX, "coorY": coorY]
        
        
        
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
                    
                    //print("ERROR2 : TraceController")
                    
                    return
                    
            }
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                print("le POST: " + postString)
                self.performSelectorOnMainThread(#selector(SigninViewController.updatePostLabel(_:)), withObject: postString, waitUntilDone: false)
                
            }
            
        }).resume()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let b = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogIn")
        if b {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}



