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
}

