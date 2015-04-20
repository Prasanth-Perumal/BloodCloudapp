//
//  Donorlist.swift
//  BloodCloudapp
//
//  Created by Prasanth on 10/04/15.
//  Copyright (c) 2015 inflexion.Prasanth. All rights reserved.
//

import Foundation
import CoreData

class Donorlist: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var bloodtype: String
    @NSManaged var lat: NSNumber
    @NSManaged var longi: NSNumber
    @NSManaged var mobile: String
    @NSManaged var city: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, bloodtype: String,lat: NSNumber,longi: NSNumber,mobile: String,city: String) ->Donorlist {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Donorlist", inManagedObjectContext: moc) as! Donorlist
        newItem.name = name
        newItem.bloodtype = bloodtype
        newItem.lat=lat
        newItem.longi=longi
        newItem.mobile=mobile
        newItem.city=city
        return newItem
    }

}
