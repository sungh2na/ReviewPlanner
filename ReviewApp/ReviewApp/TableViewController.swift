//
//  TableViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    var storedDays: [Int] = [0,1,2,3,4,5,6]
    override func viewDidLoad() {
        // days 수정
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DaysController" {
            if let secondView = segue.destination as? DaysController {
                secondView.delegate = self.storedDays
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
//        performSegue(withIdentifier: "showModify", sender: indexPath.row)
        if(indexPath.row == 1) {
            performSegue(withIdentifier: "DaysController", sender: nil)
        }
    }
}
