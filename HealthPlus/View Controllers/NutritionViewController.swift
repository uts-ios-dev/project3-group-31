//
//  NutritionViewController.swift
//  HealthPlus
//
//  Created by Jack Huggart on 22/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import HealthKit
import Foundation
import UIKit

class NutritionViewController : UIViewController {
    
    var healthStore : HKHealthStore?
    @IBOutlet weak var heightTxt: UILabel!
    @IBOutlet weak var weightTxt: UILabel!
    @IBOutlet weak var calTxt: UILabel!
    @IBOutlet weak var ageTxt: UILabel!
    @IBOutlet weak var genderTxt: UILabel!
    
    override func viewDidLoad() {
        setData()
        calTxt.text = String(calcBMR())
    }
    
    func setData() {
        setHeight()
        setWeight()
    }
    
    func setHeight() {
        let heightType = HKObjectType.quantityType(forIdentifier: .height)
        
        let heightQuery = HKSampleQuery(sampleType: heightType!,
                                        predicate: nil,
                                        limit: 1,
                                        sortDescriptors: nil)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard let newResults = results as? [HKQuantitySample] else {
                fatalError("error");
            }
            
            DispatchQueue.main.async {
                let heightResult = newResults.first?.quantity.doubleValue(for: HKUnit.meter())
                let newTxt: String = String(format:"%.2f", heightResult!)
                self.heightTxt.text = newTxt
            }
        }
        
        healthStore!.execute(heightQuery)
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
                let weightResult = newResults.first?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                let newTxt: String = String(format:"%.2f", weightResult!)
                self.weightTxt.text = newTxt
            }
        }
        
        healthStore!.execute(weightQuery)
    }
    
    func calcBMR() -> Int {
        let BMR : Double
        let weightCalc = 10 * Int(weightTxt.text!)!
        let heightCalc = 6.25 * Double(heightTxt.text!)!
        let ageCalc = 5 * Int(ageTxt.text!)!
        var ageModifier = 0.0
        
        if genderTxt.text == "M" {
            ageModifier = 5.0
        } else if genderTxt.text == "F" {
            ageModifier = -161.0
        }
        
        BMR = Double(weightCalc) + heightCalc - Double(ageCalc) + ageModifier
        
        return Int(BMR)
    }
}
