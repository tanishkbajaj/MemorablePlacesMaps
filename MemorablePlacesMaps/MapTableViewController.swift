//
//  MapTableViewController.swift
//  MemorablePlacesMaps
//
//  Created by IMCS2 on 8/9/19.
//  Copyright © 2019 Tanishk. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController: UITableViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    var titleArrayTable: [String] = []
    var vc = ViewController()
    
   
//    var toDoubleLat: Double = 0.0
//    var toDoubleLong: Double = 0.0
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("wanna see this \(savedDataTitleFromCore)")
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedDataTitleFromCore.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (savedDataTitleFromCore[indexPath.row])
        
//        toDoubleLat = Double(m[indexPath.row])!
//        toDoubleLong = Double(n[indexPath.row])!
       // print(toDoubleLat)
       // print(toDoubleLong)
        
        

        

        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    let blogSegueIdentifier = "cellToMap"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == blogSegueIdentifier,
            let destination = segue.destination as? ViewController,
            let blogIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.latitudeuse =  Double(savedDataLatFromCore[blogIndex])!
            destination.longitudeuse = Double(savedDataLongFromCore[blogIndex])!
            
            locationManager.delegate = destination
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            destination.titleName = savedDataTitleFromCore[blogIndex]
 
            
            
        }
       
        
    }
    

}
