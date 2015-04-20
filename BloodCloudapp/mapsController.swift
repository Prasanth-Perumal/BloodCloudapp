//
//  mapsController.swift
//  BloodCloudapp
//
//  Created by Prasanth on 10/04/15.
//  Copyright (c) 2015 inflexion.Prasanth. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class mapsController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    var condition:String!
    var btype:String!
    
    let locationManager = CLLocationManager()
    
    var mapView = GMSMapView()

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        println(condition)
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 3)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.delegate = self
       
        self.view = mapView
        
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Donorlist")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Donorlist] {
              var marker11 = [GMSMarker](count: fetchResults.count,repeatedValue: GMSMarker())
            for var i=0;i<fetchResults.count;i=i+1
            {
                var latit = fetchResults[i].lat as Double
                var longit = fetchResults[i].longi as Double
                var name = fetchResults[i].name
                var position = CLLocationCoordinate2DMake(latit,longit)
              
                
             marker11[i] = GMSMarker(position: position)
                

                marker11[i].title = name
               marker11[i].map = mapView
              
            }
        }
        
        
        
        //self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       
        let position = CLLocationCoordinate2DMake(manager.location.coordinate.latitude,manager.location.coordinate.longitude)
        
        let marker = GMSMarker(position: position)
        marker.title = "mylocation"
        marker.map = self.mapView
        mapView.camera = GMSCameraPosition(target: position, zoom: 6, bearing: 0, viewingAngle: 0)
               CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            println(locality)
            println(postalCode)
            println(administrativeArea)
            println(country)
        }
        
    }
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
       
        
        self.performSegueWithIdentifier("routemapsegue",sender : marker)
        
    }

    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
       
            
            var svc = segue!.destinationViewController as! routeController;
        
            svc.googleMarker = sender as! GMSMarker
       
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


