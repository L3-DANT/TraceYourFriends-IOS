//
//  TraceController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit

class TraceController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
            NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: #selector(TraceController.updateCoor), userInfo: nil, repeats: true)
        })
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
        let name = NSUserDefaults.standardUserDefaults().valueForKey("myName") as! String
        sendJson(name, coorX: location.coordinate.latitude, coorY: location.coordinate.longitude)
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



