//
//  DetialsViewController.swift
//  HealthPlus
//
//  Created by Alex Tsimboukis on 9/6/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class DetailsViewController : UIViewController {
    var healthStore : HKHealthStore?
    
    //textlabels
    @IBOutlet weak var heightTxt: UITextField!
    @IBOutlet weak var weightTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func deletePreviousHeightData() {
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: [])
        healthStore?.deleteObjects(of: HKObjectType.quantityType(forIdentifier: .height)!, predicate: predicate, withCompletion: {success, amountDeleted, error in
            print("Deletion success")}
        )
    }
    
    func deletePreviousWeightData() {
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: [])
        healthStore?.deleteObjects(of: HKObjectType.quantityType(forIdentifier: .bodyMass)!, predicate: predicate, withCompletion: {success, amountDeleted, error in
            print("Deletion success")}
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let forDate = Date()
        if let height = heightTxt.text
        {
            deletePreviousHeightData()
            let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
            let heightData = HKQuantitySample (type: quantityType,
                                               quantity: HKQuantity.init(unit: HKUnit.meter(), doubleValue: Double(height)!),
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
        if let weight = weightTxt.text
        {
            deletePreviousWeightData()
            let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
            let weightData = HKQuantitySample (type: quantityType,
                                               quantity: HKQuantity.init(unit: HKUnit.gramUnit(with: .kilo), doubleValue: Double(weight)!),
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
        if let nutritionScene = segue.destination as? NutritionViewController {
            nutritionScene.healthStore = healthStore
        }
    }
    
}


