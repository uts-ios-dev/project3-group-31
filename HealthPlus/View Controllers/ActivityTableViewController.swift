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

class ActivityTableViewController : UITableViewController {
    var healthStore : HKHealthStore?
    @IBOutlet weak var bpmTxt: UILabel!
    
    override func viewDidLoad() {
        let hrType = HKObjectType.quantityType(forIdentifier: .heartRate)
        
        let hrQuery = HKSampleQuery(sampleType: hrType!,
                                       predicate: nil,
                                       limit: 1,
                                       sortDescriptors: nil)
        { (query:HKSampleQuery, results:[HKSample]?, error:Error?) -> Void in
            
            guard error == nil else { print("error"); return }
            
            DispatchQueue.main.async {
                self.bpmTxt.text = results?.first.debugDescription
            }
        }
        
        healthStore?.execute(hrQuery)
    }
}
