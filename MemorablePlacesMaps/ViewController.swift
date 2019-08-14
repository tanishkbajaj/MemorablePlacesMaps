//
//  ViewController.swift
//  MemorablePlacesMaps
//
//  Created by IMCS2 on 8/9/19.
//  Copyright © 2019 Tanishk. All rights reserved.
//

import UIKit
import MapKit
import CoreData

var nonRepeatLat: [String] = []
var nonRepeatLong: [String] = []

var savedDataLatFromCore: [String] = []
var savedDataLongFromCore: [String] = []
var savedDataTitleFromCore: [String] = []




class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    var latArray: [String] = []
    var longArray: [String] = []
    var saveObject = [NSManagedObject]()
    
   
    var titleName = ""
    
    var lat  = ""
    var long = ""
    
    var latitudeuse: CLLocationDegrees = 0.0
    var longitudeuse: CLLocationDegrees = 0.0
    var titleArrayView: [String] = []
    var annotations1 = MKPointAnnotation()
  
     var locationManager = CLLocationManager()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        //Add long press gesture
        let uiLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gestureRecogniser: )))
        uiLongPress.minimumPressDuration = 2.0
        map.addGestureRecognizer(uiLongPress)
    
        fetchFromCoreData()
  
    }
    
   
        
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let userLocation: CLLocation = locations[0]
        
        let latitude: CLLocationDegrees =  latitudeuse
        let longitude: CLLocationDegrees = longitudeuse
        let latDelta: CLLocationDegrees = 10
        let longDelta: CLLocationDegrees = 10
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // print(coordinates)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
    }
    
    
    @objc func longPressAction(gestureRecogniser: UIGestureRecognizer){
        
        let alert = UIAlertController(title: "Memorable App", message: "Enter City Name", preferredStyle: .alert)
        var annotations = MKPointAnnotation()
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        let touchPoint = gestureRecogniser.location(in: self.map)
        let coordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField.text!)")
            annotations.title = textField.text!
            //self.titleArrayView.append(annotations.title!)
            
            savedDataTitleFromCore.append(annotations.title!)
            annotations.subtitle = "Long press Gesture ... "
           
            self.lat = String(coordinate.latitude)
            savedDataLatFromCore.append(self.lat)
            // print("lat array \(latArray)")
            self.long =  String(coordinate.longitude)
            savedDataLongFromCore.append(self.long)
            
            annotations.coordinate = coordinate
            self.map.addAnnotation(annotations)
            
           self.save(latArraySave: savedDataLatFromCore, longArraySave: savedDataLongFromCore, titleArraySave: savedDataTitleFromCore)
        }))
        //print("this is array \(self.titleArrayView)")
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
       // print(coordinate)
        
        
       
   
    }
    
    
   

    
    override func viewDidAppear(_ animated: Bool) {
        
//        var annotations = MKPointAnnotation()
        let latitude: CLLocationDegrees =  latitudeuse
        let longitude: CLLocationDegrees = longitudeuse
        let latDelta: CLLocationDegrees = 10
        let longDelta: CLLocationDegrees = 10
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // print(coordinates)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        annotations1.title = titleName
        annotations1.coordinate = coordinates
        map.addAnnotation(annotations1)
       
    }

    
    
    func save(latArraySave: [String], longArraySave: [String], titleArraySave: [String]) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Maps",
                                       in: managedContext)!
        
        let mapsdata = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        // 3
        mapsdata.setValue(latArraySave, forKeyPath: "latitude")
        mapsdata.setValue(longArraySave, forKeyPath: "longitude")
        mapsdata.setValue(titleArraySave, forKeyPath: "title")
        // person.setValue(age, forKeyPath: "age")
        // 4
        do {
            try managedContext.save()
            saveObject.append(mapsdata)
            print("this is save obj \(saveObject)")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    func fetchFromCoreData() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Maps")
        
        //3
        do {
            saveObject = try managedContext.fetch(fetchRequest)
            for blogs in saveObject{
                //adding values to the saved data array
                savedDataLatFromCore = (blogs.value(forKeyPath: "latitude") as? [String])!
                savedDataLongFromCore = (blogs.value(forKeyPath: "longitude") as? [String])!
                savedDataTitleFromCore = (blogs.value(forKeyPath: "title") as? [String])!
                // let age = person.value(forKeyPath: "age") as? Int
                
                
            }

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
    
    
    let blogSegueIdentifier = "viewToCell"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        save(latArraySave: nonRepeatLat, longArraySave: nonRepeatLong, titleArraySave: titleArrayView)
//
//        fetchFromCoreData()
        print(" title just after fetch\(savedDataTitleFromCore)")
        
        
        if  segue.identifier == blogSegueIdentifier,
            let destination = segue.destination as? MapTableViewController {
            destination.titleArrayTable = titleArrayView
           
            
        }
        
     
        
        
    }
    
    
    
    


}

