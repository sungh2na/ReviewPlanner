//
//  NotificationViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/11/05.
//

import UIKit
import CoreData

class NotificationViewController: UITableViewController {
    
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var notiSwitch: UISwitch!
    
    let datePicker = UIDatePicker()
    var hour: Int = 9
    var minute: Int = 00
    var notiTime: [NotiTime] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var container = appDelegate.persistentContainer
    lazy var context = container.viewContext
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<NotiTime> = NotiTime.fetchRequest()
        self.notiTime = try! context.fetch(request)
       
        if notiTime.isEmpty {
            notiSwitch.isOn = false
            dateTxt.textAlignment = .right
            dateTxt.text = "오전 9:00"
        } else {
            dateTxt.text = formatter.string(from: notiTime[0].date!)
            notiSwitch.isOn = true
//            hour = notiTime[0]
            formatter.dateFormat = "hh"
            hour = Int(formatter.string(from: notiTime[0].date!))!        // 수정
            formatter.dateFormat = "mm"
            minute = Int(formatter.string(from: notiTime[0].date!))!      // 수정
        }
        
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
    }
    
    @objc func donePressed() {
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
            if !notiTime.isEmpty{
                let object = context.object(with: notiTime[0].objectID)
                context.delete(object)
            }
            let notiTime = NotiTime(context: context)
            notiTime.date = datePicker.date
            try! context.save()
        } else {
            notificationManager.cancelNotification()
        }
    }
}

