//
//  RegisterController.swift
//  BloodCloudapp
//
//  Created by Prasanth on 13/04/15.
//  Copyright (c) 2015 inflexion.Prasanth. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class RegisterController:UIViewController
{
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var donor: UIButton!
    @IBOutlet weak var seeker: UIButton!
    @IBOutlet weak var both: UIButton!
    
    @IBOutlet weak var header: UIView!
    
    
    @IBOutlet weak var edttxt_city: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var edttxt_address: UITextField!
    @IBOutlet weak var edttxt_bloodtype: UITextField!
    @IBOutlet weak var edttxt_mobile: UITextField!
    @IBOutlet weak var edttxt_name: UITextField!
    var radioButtonController = SSRadioButtonsController()
    override func viewDidLoad() {
        super.viewDidLoad()
       radioButtonController.setButtonsArray([donor!,seeker!,both!])
        var currentButton = radioButtonController.selectedButton()
        

    }
    
    @IBAction func registeruser(sender: AnyObject) {
//        let donor1 = NSEntityDescription.insertNewObjectForEntityForName("Donorlist", inManagedObjectContext: self.managedObjectContext!) as! Donorlist
        let entityDescription =
        NSEntityDescription.entityForName("Donorlist",
            inManagedObjectContext: self.managedObjectContext!)
        
        let donor1 = Donorlist(entity: entityDescription!,
            insertIntoManagedObjectContext: self.managedObjectContext)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(edttxt_address.text, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    let coords = location.coordinate
                    
                    donor1.setValue(self.edttxt_name.text, forKey: "name")
                    donor1.setValue(self.edttxt_bloodtype.text, forKey: "bloodtype")
                    donor1.setValue(coords.latitude, forKey: "lat")
                    donor1.setValue(coords.longitude, forKey: "longi")
                    donor1.setValue(self.edttxt_mobile.text, forKey: "mobile")
                    donor1.setValue(self.edttxt_city.text, forKey: "city")
                    var error: NSError?
                    if !self.managedObjectContext!.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }

                    
                }
        })
        
        
        
       
        
        let alert = UIAlertController(title: "Thank You for Rgistering",
            message: edttxt_name.text,
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        // Display the alert
        self.presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    
}