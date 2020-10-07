//
//  ModifyViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/07.
//

import UIKit

protocol Edit_2_Delegate{
    func modifyButtonTapped(_ detail: String, _ date: Date)
}

class ModifyViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var inputTextField: UITextField!
    var delegate: Edit_2_Delegate?
    var detail: String?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .wheels
        updateUI()
    }
    
    func updateUI() {
        if let detail = self.detail, let date = self.date {
            inputTextField.text = detail
            datePicker.date = date
        }
    }
    
    @IBAction func date(_ sender: Any) {
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.modifyButtonTapped(inputTextField.text!, datePicker.date)
        }
        dismiss(animated: true, completion: nil)
    }
}
