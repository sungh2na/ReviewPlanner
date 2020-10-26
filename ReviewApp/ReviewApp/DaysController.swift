//
//  DaysController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/18.
//

import Foundation
import UIKit

protocol Edit_3_Delegate{
    func storedDays(_ days: [Int])
}

class DaysController : UITableViewController {
    var storedDays: [Int]?
    var days: [Int] = [0]
    var delegate: Edit_3_Delegate?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let storedDays = self.storedDays else { return }
        days = storedDays
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = days.contains(indexPath.row) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = days.firstIndex(of: indexPath.row) {
            days.remove(at: index)
        } else {
            days.append(indexPath.row)
        }
        delegate?.storedDays(days)
        tableView.reloadData()
    }
}
