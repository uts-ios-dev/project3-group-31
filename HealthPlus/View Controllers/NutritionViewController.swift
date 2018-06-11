//
//  NutritionViewController.swift
//  HealthPlus
//
//  Created by Jack Huggart on 22/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//  Edited by Alexander Tsimboukis
//

import HealthKit
import Foundation
import UIKit

class NutritionViewController : UIViewController {
    
    var healthStore : HKHealthStore?
    @IBOutlet weak var heightTxt: UILabel!
    var height: Double? = nil
    @IBOutlet weak var weightTxt: UILabel!
    var weight: Double? = nil
    @IBOutlet weak var calTxt: UILabel!
    @IBOutlet weak var ageTxt: UILabel!
    @IBOutlet weak var genderTxt: UILabel!
    
    
    var heightCalc = 0.0
    var weightCalc = 0.0
    var ageCalc = 0
    var ageModifier = 0.0
    
    var newHeight:String?
    var newWeight:String?
    var newAge:String?
    var newGender:String?
    var manual_update = false

    
    @IBAction func calcBtn(_ sender: Any) {
        calTxt.text = String(calcBMR()) + " calories"
    }
    
    override func viewDidLoad() {
<<<<<<< HEAD
        getData()
        if manual_update == false {
            setData()
        }
=======
        setData()
>>>>>>> 1bf447da112485bc6608c3e136635e7d4483ee86
        calTxt.text = ""
    }
    
    
<<<<<<< HEAD
    func getData()
    {
        
        //if the user updates data manually
        if let recievedHeight = newHeight
        {
            heightTxt.text = recievedHeight
            manual_update = true
        }
        if let recievedWeight = newWeight
        {
            weightTxt.text = recievedWeight
        }
        if let recievedAge = newAge
        {
            ageTxt.text = recievedAge
        }
        if let recievedGender = newGender
        {
            genderTxt.text = recievedGender
        }
        

    }
    
    
=======
>>>>>>> 1bf447da112485bc6608c3e136635e7d4483ee86
    func setData() {
        //get data from hkit
        setHeight()
        setWeight()
        setAge()
        setGender()
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
            self.height = newResults.first?.quantity.doubleValue(for: HKUnit.meter())
              if (self.height != nil) {
                if let newTxt: String = String(format:"%.2f", self.height!) {
                    self.heightTxt.text = newTxt + " m"
                  }
               }
            }
        }
        
        if healthStore != nil {
              healthStore!.execute(heightQuery)
        }

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
                if self.weight != nil
                {
                    if let newTxt: String = String(format:"%.2f", self.weight!)
                    {
                        self.weightTxt.text = newTxt + " kg"
                    }
                }
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
            let age = ageComponents.year
            ageTxt.text = String(age!)
            
        } catch {
            print("Error fetching DOB")
        }
    }
    
    func setGender() {
        do {
            let gender = try healthStore!.biologicalSex().biologicalSex
            if gender == HKBiologicalSex.male {
                genderTxt.text = "Male"
            } else if gender == HKBiologicalSex.female {
                genderTxt.text = "Female"
            }
        } catch {
            print("Error fetching sex")
        }
    }
    
    func calcBMR() -> Int {
        let BMR : Double
        
        if (height != nil) {
            heightCalc = 6.25 * (height! * 100)
        }
        if (weight != nil){
            weightCalc = 10 * weight!
        }
        if (ageTxt.text != nil) {
            ageCalc = 5 * Int(ageTxt.text!)!
        }
        
        if genderTxt.text == "Male" {
            ageModifier = 5.0
        } else if genderTxt.text == "Female" {
            ageModifier = -161.0
        }
        
        BMR = Double(weightCalc) + Double(heightCalc) - Double(ageCalc) + ageModifier
        
        return Int(BMR)
    }
}
