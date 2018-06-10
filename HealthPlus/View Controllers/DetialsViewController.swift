//
//  DetialsViewController.swift
//  HealthPlus
//
//  Created by Alex Tsimboukis on 9/6/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController : UIViewController {
    
    //textlabels
    @IBOutlet weak var heightLabel: UITextField!
    
    @IBOutlet weak var weightLabel: UITextField!
    
    @IBOutlet weak var ageLabel: UITextField!
    
    @IBOutlet weak var genderLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVC = segue.destination as! NutritionViewController
        if let height = heightLabel.text
        {
            recieverVC.newHeight = height
        }
        if let weight = weightLabel.text
        {
            recieverVC.newWeight = weight
        }
        if let age = ageLabel.text
        {
            recieverVC.newAge = age
        }
        if let gender = genderLabel.text
        {
            recieverVC.newGender = gender
        }
        

    }
    
}


