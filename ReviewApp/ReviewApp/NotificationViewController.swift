//
//  NotificationViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/11/05.
//

import UIKit

class NotificationViewController: UITableViewController {
    
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var notiSwitch: UISwitch!
    
    let datePicker = UIDatePicker()
    var hour: Int = 9
    var minute: Int = 00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        notiSwitch.isOn = false
        dateTxt.textAlignment = .right
        dateTxt.text = "오전 9:00"
        // Do any additional setup after loading the view.
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
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        dateTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        formatter.dateFormat = "hh"
        hour = Int(formatter.string(from: datePicker.date))!        // 수정
        formatter.dateFormat = "mm"
        minute = Int(formatter.string(from: datePicker.date))!      // 수정
        switchDidChange(notiSwitch)
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        let notificationManager = NotificationManager.shared
        if sender.isOn {
            notificationManager.schedule(hour: hour, minute: minute)
        } else {
            notificationManager.cancelNotification()
        }
    }
}

