//
//  DaysController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/18.
//

import Foundation
import UIKit

class DaysContoller : UITableViewController {
    var days: [Int] = [0,1,2,3,4,5,6]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
}
