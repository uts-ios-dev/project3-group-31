//
//  ViewController.swift
//  HealthPlus
//
//  Created by Jack Huggart on 22/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    var healthStore : HKHealthStore?
    
    func requestPerms() {
        let allDataTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore!.requestAuthorization(toShare: allDataTypes, read: allDataTypes) { (success, error) in
            if !success {
                print("Failed to access")
            }
        }
    }
    
    
    // WRITE A SAMPLE HEART RATE TO HEALTHKIT FOR USE ON ACTIVITY TRACKER (executed during segue)
    public func submitHR(HR: Int, forDate : Date) {
        let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let heartRate = HKQuantitySample (type: quantityType,
                                          quantity: HKQuantity.init(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: Double(HR)),
                                         start: forDate,
                                         end: forDate)
        healthStore!.save(heartRate) { success, error in
            if (error != nil) {
                print("Error: \(String(describing: error))")
            }
            if success {
                print("Saved: \(success)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestPerms()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let activityScene = segue.destination as? ActivityTableViewController {
            activityScene.healthStore = healthStore
            submitHR(HR: 67, forDate: Date())
        }
    }
}

