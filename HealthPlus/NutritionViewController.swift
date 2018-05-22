//
//  NutritionViewController.swift
//  HealthPlus
//
//  Created by Jack Huggart on 22/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import UIKit

class NutritionViewController : UIViewController {
    
    @IBOutlet weak var heightTxt: UILabel!
    @IBOutlet weak var weightTxt: UILabel!
    @IBOutlet weak var calTxt: UILabel!
    @IBOutlet weak var ageTxt: UILabel!
    @IBOutlet weak var genderTxt: UILabel!
    
    override func viewDidLoad() {
        calTxt.text = String(calcBMR())
    }
    
    func calcBMR() -> Int {
        let BMR : Double
        let weightCalc = 10 * Int(weightTxt.text!)!
        let heightCalc = 6.25 * Double(Int(heightTxt.text!)!)
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
