//
//  TraceController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 06/04/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit
import MapKit

class TraceController: TabBarController, MKMapViewDelegate {
    
    @IBOutlet weak var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.setUserTrackingMode(.Follow, animated: true)
    }

    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let width = 1000.0 //meters
        let height = 1000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
        mapView.setRegion(region, animated: true)
    }
    
}
