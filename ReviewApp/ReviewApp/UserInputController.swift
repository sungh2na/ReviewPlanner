//
//  UserInputController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/27.
//

import UIKit

protocol UserInputDelegate{
    func userInputButtonTapped(_ interval: [Int])
}

class UserInputController: UIViewController {
    
    @IBOutlet weak var inputNumberField: UITextField!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var delegate: UserInputDelegate?    
    var interval = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.userInputButtonTapped(interval)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        guard let inputInterval = inputNumberField.text else { return }
        interval.append(Int(inputInterval)!)    // 수정해야함
        intervalLabel.text = interval.map {
            if $0 == 0 {
                return "오늘"
            } else {
                return ", \($0)일"
            }
        }.joined()
        inputNumberField.text = ""
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if interval.count > 1 {
            interval.removeLast()
        }
        intervalLabel.text = interval.map {
            if $0 == 0 {
                return "오늘"
            } else {
                return ", \($0)일"
            }
        }.joined()
    }
}
