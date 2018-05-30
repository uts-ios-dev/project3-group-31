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
                                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                HKObjectType.quantityType(forIdentifier: .height)!,
                                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!])
        
        healthStore!.requestAuthorization(toShare: allDataTypes as? Set<HKSampleType>, read: allDataTypes) { (success, error) in
            if !success {
                print("Failed to access")
            }
        }
    }
    
    
    // WRITE SAMPLE DATA TO HEALTHKIT FOR USE IN OTHER SCENES (executed during segue)
    public func submitData(HR: Int, height: Double, weight: Double, forDate: Date) {
        sampleHR(HR: HR, forDate: forDate)
        sampleHeight(height: height, forDate: forDate)
        sampleWeight(weight: weight, forDate: forDate)
    }
    
    func sampleHR(HR: Int, forDate: Date) {
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
    
    func sampleHeight(height: Double, forDate: Date) {
        let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let heightData = HKQuantitySample (type: quantityType,
                                           quantity: HKQuantity.init(unit: HKUnit.meter(), doubleValue: Double(height)),
                                           start: forDate,
                                           end: forDate)
        healthStore!.save(heightData) { success, error in
            if (error != nil) {
                print("Error: \(String(describing: error))")
            }
            if success {
                print("Saved: \(success)")
            }
        }
    }
    
    func sampleWeight(weight: Double, forDate: Date) {
        let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let weightData = HKQuantitySample (type: quantityType,
                                           quantity: HKQuantity.init(unit: HKUnit.gramUnit(with: .kilo), doubleValue: Double(weight)),
                                           start: forDate,
                                           end: forDate)
        healthStore!.save(weightData) { success, error in
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
            submitData(HR: 67, height: 1.84, weight: 78.25, forDate: Date())
        }
        if let nutritionScene = segue.destination as? NutritionViewController {
            submitData(HR: 67, height: 1.84, weight: 78.25, forDate: Date())
            nutritionScene.healthStore = healthStore
        }
    }
}

