//
//  ViewController.swift
//  BloodCloudapp
//
//  Created by Prasanth on 09/04/15.
//  Copyright (c) 2015 inflexion.Prasanth. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var header: UIView!
 
    @IBOutlet weak var body: UIView!
    
    @IBAction func searcher(sender: AnyObject) {
        performSegueWithIdentifier("searching", sender: self)
        
    }
    
    @IBOutlet weak var btnblood: UITextField!
    
    @IBOutlet weak var condition: UITextField!
    
    var bloodtypes = ["A+","B+","O+","AB+","A-","B-","O-","AB-"]
    var bdcondition = ["PMD Platelets"]
    let bloodpicker:UIPickerView! = UIPickerView()
    let conditionpicker:UIPickerView! = UIPickerView()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.bringSubviewToFront(body)
        body.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
       
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.clipsToBounds=false
        let mister=UIView().addheader(self)
        mister.frame = header.bounds
        header.addSubview(mister)
        
        
        
        // headr b buttons
        var a = self.view.viewWithTag(22) as! UIButton!
        a.addTarget(self, action: "btnTouched:", forControlEvents: UIControlEvents.TouchDown)
        var b = self.view.viewWithTag(23) as! UIButton!
        b.addTarget(self, action: "btnTouched:", forControlEvents: UIControlEvents.TouchDown)
        var c = self.view.viewWithTag(24) as! UIButton!
        c.addTarget(self, action: "btnTouched:", forControlEvents: UIControlEvents.TouchDown)
        var d = self.view.viewWithTag(25) as! UIButton!
         d.frame = CGRectMake(header.bounds.width-45,25,20, 20)
        d.addTarget(self, action: "btnTouched:", forControlEvents: UIControlEvents.TouchDown)
        
        //pickerView
        bloodpicker.tag=123
        conditionpicker.tag=432
        self.bloodpicker.dataSource=self
        self.bloodpicker.delegate=self
        conditionpicker.dataSource=self
        conditionpicker.delegate=self
        btnblood.delegate=self
        btnblood.inputView=bloodpicker
        condition.delegate=self
        condition.inputView=conditionpicker
        
        var defaultdata = NSUserDefaults.standardUserDefaults()
       
        if(defaultdata.stringForKey("userNameKey") != "yes" )
        {
            println(defaultdata.stringForKey("userNameKey"))
            defaultdata.setObject("yes", forKey: "userNameKey")
            // insert data into db
          let donor = NSEntityDescription.insertNewObjectForEntityForName("Donorlist", inManagedObjectContext: self.managedObjectContext!) as! Donorlist
          
//            
//            let board = result as Board
//            let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: context) as List
//            println("💃 want to save \(listName) in \(board.boardName)")
//            board.lists.addListObject(lists)
            
            
            
            donor.name="prasanth"
            donor.bloodtype="A+"
            donor.lat=12.87
            donor.longi=71.5
            donor.mobile="9789401056"
            donor.city="bangalore"
            
//
////           let donor2 = NSEntityDescription.insertNewObjectForEntityForName("Donorlist", inManagedObjectContext: self.managedObjectContext!) as! Donorlist
//            donor.name="prasanth2"
//            donor.bloodtype="A+"
//            donor.lat=12.87
//            donor.longi=71.5
//            donor.mobile="9789401056"
//            donor.city="bangalore"

}
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
     
           }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "searching") {
            
          var svc = segue!.destinationViewController as! mapsController;
           
            svc.condition = condition.text
            svc.btype = btnblood.text
            
        }
    }

    
    

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
       if(pickerView.tag==123)
       {
        btnblood.text = bloodtypes[row]
        
        btnblood.endEditing(true)
        }
        if(pickerView.tag==432)
        {
            condition.text = bdcondition[row]
                       condition.endEditing(true)
        }
      
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag==123)
        {
        return bloodtypes.count
        }
        if(pickerView.tag==432)
        {return bdcondition.count}
        return 0
    }
    
    // pragma MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag==123)
        {
            return bloodtypes[row]
        }
        if(pickerView.tag==432)
        {
            return bdcondition[row]
        
        }
        
        return "null"
            }
    
    func btnTouched(sender : UIButton) {
        
if(sender.tag == 23)
{
self.performSegueWithIdentifier("123",sender : self)

}
else
{

let fetchRequest = NSFetchRequest(entityName: "Donorlist")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Donorlist]
        {
            
            // Create an Alert, and set it's message to whatever the itemText is
            let alert = UIAlertController(title: fetchResults[0].name,
                message: fetchResults[0].lat.stringValue,
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            // Display the alert
            self.presentViewController(alert,
                animated: true,
                completion: nil)
        }
       
    }

    
   
    
}
}


