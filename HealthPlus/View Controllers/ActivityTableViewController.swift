//
//  ActivityTableViewController.swift
//  HealthPlus
//
//  Created by Jack Huggart on 22/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import HealthKit
import UIKit
import MapKit


class ActivityTableViewController : UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var healthStore : HKHealthStore?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var weight: Double? = 0
    var gender: String? = nil
    var heartrate: Double? = 0
    var age: Int? = 0

    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        setHeartRate()
        setWeight()
        setAge()
        setGender()
    }
    
    func setWeight() {
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)
        
        let weightQuery = HKSampleQuery(sampleType: weightType!,
                                        predicate: nil,
                                        limit: 1,
                                        sortDescriptors: nil)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard let newResults = results as? [HKQuantitySample] else {
                fatalError("error");
            }
            
            DispatchQueue.main.async {
                self.weight = newResults.first?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            }
        }
        if healthStore != nil {
            healthStore!.execute(weightQuery)
        }
    }
    
    func setAge() {
        do {
            let dateOfBirth = try healthStore!.dateOfBirthComponents()
            let now = Date()
            let ageComponents = Calendar.current.dateComponents([.year], from: dateOfBirth.date!, to: now)
            let ageResult = ageComponents.year
            age = Int(ageResult!)
            
        } catch {
            print("Error fetching DOB")
        }
    }
    
    func setGender() {
        do {
            let genderResult = try healthStore!.biologicalSex().biologicalSex
            if genderResult == HKBiologicalSex.male {
                gender = "Male"
            } else if genderResult == HKBiologicalSex.female {
                gender = "Female"
            }
        } catch {
            print("Error fetching sex")
        }
    }

    
    func setHeartRate() {
        let hrType = HKObjectType.quantityType(forIdentifier: .heartRate)
        
        let hrQuery = HKSampleQuery(sampleType: hrType!,
                                        predicate: nil,
                                        limit: 1,
                                        sortDescriptors: nil)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard let newResults = results as? [HKQuantitySample] else {
                fatalError("error");
            }
            
            DispatchQueue.main.async {
                let hrResult = newResults.first?.quantity.doubleValue(for: (HKUnit.count()).unitDivided(by: HKUnit.minute()))
                if (hrResult != nil)
                {
                    self.heartrate = hrResult
                    self.heartRateLabel.text = String(Int(self.heartrate!)) + " bpm"
                }
            }
        }
        
        healthStore!.execute(hrQuery)
    }
    
    //Override the Update location function, so that I can act whenever iOS updates the map with my new location
    func locationManager(_ _manager : CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let start = locations.first!
        print(start)
        let location = locations.last!
        print(location)

        //Set to the whole area of the map shows 500 by 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        //Set my current location using a 2d point so I can being drawing with it.
        
        let currLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //speedLabel.text = "\(location.speed)"
        
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
