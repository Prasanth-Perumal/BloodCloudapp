//
//  routeController.swift
//  BloodCloudapp
//
//  Created by Prasanth on 15/04/15.
//  Copyright (c) 2015 inflexion.Prasanth. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class routeController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    var mapView = GMSMapView()
    var googleMarker:GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 3)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.delegate = self
        
        self.view = mapView
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
      
        println(googleMarker.title)
        
}
   
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let position = CLLocationCoordinate2DMake(manager.location.coordinate.latitude,manager.location.coordinate.longitude)
        
        let marker = GMSMarker(position: position)
        marker.title = "mylocation"
        marker.map = self.mapView
      mapView.camera = GMSCameraPosition(target: position, zoom: 6, bearing: 0, viewingAngle: 0)
        
      
        googleMarker.map=self.mapView
        dataProvider.fetchDirectionsFrom(manager.location.coordinate, to: googleMarker.position) {optionalRoute in
            if let encodedRoute = optionalRoute {
                // 3
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                // 4
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
               
            }
        }
        
    
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
        // Create an Alert, and set it's message to whatever the itemText is
        let alert = UIAlertController(title: "Sorry",
            message: "We couldnt get your location",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        // Display the alert
        self.presentViewController(alert,
            animated: true,
            completion: nil)
    }



}