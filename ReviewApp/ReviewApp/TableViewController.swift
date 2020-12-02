//
//  TableViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var notiSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DaysSettingSegue" {
//            if let secondView = segue.destination as? DaysController {
//                secondView.delegate = self
//                secondView.days = self.storedDays
//            }
//        }
    }
}
