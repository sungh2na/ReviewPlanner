//
//  ModifyViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/07.
//

import UIKit

protocol ModifyDelegate{
    func modifytodo(_ todo: Todo)
}

class ModifyViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var inputTextField: UITextField!
    
    var delegate: ModifyDelegate?
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .wheels
        updateUI()
    }
    
    func updateUI() {
        if let todo = self.todo {
            inputTextField.text = todo.detail
            datePicker.date = todo.date!
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func done(_ sender: Any) {
//        var todayTodo: Todo
        if delegate != nil {
            if let todo = self.todo {
//                todayTodo = todo
                todo.detail = inputTextField.text! // 수정
                todo.date = datePicker.date
                delegate?.modifytodo(todo)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
}

