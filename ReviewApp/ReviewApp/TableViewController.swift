//
//  TableViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var daysLabel: UILabel!
    
//    var storedDays: [Int] = [0,1,2,3,4,5,6]     // Storage 저장해줘야함
//    var daysDic: [Int:String] = [0:"월", 1:"화", 2:"수", 3:"목", 4:"금", 5:"토", 6:"일"]
    override func viewDidLoad() {
        // days 수정
        super.viewDidLoad()
//        daysLabel.text = storedDays.sorted().reduce("") { $0 + daysDic[$1,default: ""] + " " }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DaysSettingSegue" {
//            if let secondView = segue.destination as? DaysController {
//                secondView.delegate = self
//                secondView.days = self.storedDays
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
//        if indexPath.row == 1 {
//            performSegue(withIdentifier: "DaysController", sender: nil)
//        }
        
//        if indexPath.section == 0, indexPath.row == 0 {
//            if let controller = self.storyboard?.instantiateViewController(identifier: "NoticeController") {
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//        }
    }
    
//    func storedDays(_ days: [Int]) {
//        storedDays = days
//        daysLabel.text = storedDays.sorted().reduce("") { $0 + daysDic[$1,default: ""] + " " }
//    }
}
