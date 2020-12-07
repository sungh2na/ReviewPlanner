//
//  TableViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/22.
//

import Foundation
import UIKit
import CoreData

class SettingViewController: UITableViewController {

    @IBOutlet weak var notiSwitch: UISwitch!
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
        dateTxt.textAlignment = .right
        dateTxt.text = notiTime[0].date!.toString(format: "a hh:mm") // 수정
        notiSwitch.isOn = notiTime[0].isOn
        hour = Int(notiTime[0].date!.toString(format: "HH"))!   // 수정
        minute = Int(notiTime[0].date!.toString(format: "mm"))!
        createDatePicker()
    }
    
    func createDatePicker() {
        dateTxt.textAlignment = .right
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
    
        dateTxt.inputAccessoryView = toolbar
        dateTxt.inputView = datePicker
        
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.date = notiTime[0].date!     // 수정
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
        dateTxt.text = datePicker.date.toString(format: "a hh:mm")
        hour = Int(datePicker.date.toString(format: "HH"))!        // 수정
        minute = Int(datePicker.date.toString(format: "m"))!       // 수정
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
}

