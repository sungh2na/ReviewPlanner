//
//  NotiViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/11/05.
//

import UIKit

class NotiViewController: UIViewController {

    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    
    func createDatePicker() {
        dateTxt.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        toolbar.setItems([doneButton], animated: true)
        
        dateTxt.inputAccessoryView = toolbar
        dateTxt.inputView = datePicker
        
        datePicker.datePickerMode = .time
    }
    
    func donePressed() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        dateTxt.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }

}
