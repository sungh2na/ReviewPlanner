//
//  SettingViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/22.
//

import Foundation
import UIKit
import CoreData

class SettingViewController: UITableViewController {

    @IBOutlet weak var notiSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTxt: UITextField!
    
    let datePicker = UIDatePicker()
    var hour: Int = 9
    var minute: Int = 0
    var notiTime: [NotiTime] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var container = appDelegate.persistentContainer
    lazy var context = container.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<NotiTime> = NotiTime.fetchRequest()
        self.notiTime = try! context.fetch(request)
        dateLabel.textAlignment = .right
        
        dateLabel.text = (notiTime[0].date ?? Date()).toString(format: "a hh:mm")
        notiSwitch.isOn = notiTime[0].isOn
        hour = Int((notiTime[0].date ?? Date()).toString(format: "HH")) ?? 9
        minute = Int((notiTime[0].date ?? Date()).toString(format: "mm")) ?? 0
        createDatePicker()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
    
        dateTxt.inputAccessoryView = toolbar
        dateTxt.inputView = datePicker
        
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .systemBackground
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.date = notiTime[0].date ?? Date()
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
        dateLabel.text = datePicker.date.toString(format: "a hh:mm")
        hour = Int(datePicker.date.toString(format: "HH")) ?? 9
        minute = Int(datePicker.date.toString(format: "m")) ?? 0
        switchDidChange(notiSwitch)
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        let notificationManager = NotificationManager.shared
        if sender.isOn {
            notificationManager.schedule(hour: hour, minute: minute)
            let object = context.object(with: notiTime[0].objectID)
            context.delete(object)
            let newNotiTime = NotiTime(context: context)
            newNotiTime.date = datePicker.date
            newNotiTime.isOn = true
            try! context.save()
        } else {
            notificationManager.cancelNotification()
            let request: NSFetchRequest<NotiTime> = NotiTime.fetchRequest()
            self.notiTime = try! context.fetch(request)
            notiTime[0].isOn = false
            try! context.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 1 {
            dateTxt.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

