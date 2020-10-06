//
//  AddViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/03.
//

import UIKit

protocol EditDelegate{
    func addTaskButtonTapped(_ detail: String, _ interval: [Int])
    func modifyButtonTapped(_ detail: String, _ date: Date)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var intervalLabel: UILabel!
    var delegate: EditDelegate?
    var interval = [0, 1, 5, 10, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.addTaskButtonTapped(inputTextField.text!, interval)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func setInterval(_ sender: Any) {
        interval = [0, 1, 5, 10, 30]
        let alert = UIAlertController(title:"복습 간격 선택", message: "원하는 복습 간격이 없을 경우 직접 입력", preferredStyle: .actionSheet)
        let interval_1 =  UIAlertAction(title: "오늘, 1일, 3일, 7일, 15일", style: .default) {
            (action) in self.intervalLabel.text = "오늘, 1일, 3일, 7일, 15일"
            self.interval = [0, 1, 3, 7, 15]
        }
        let interval_2 =  UIAlertAction(title: "오늘, 1일, 5일, 10일, 20일", style: .default) {
            (action) in self.intervalLabel.text = "오늘, 1일, 5일, 10일, 30일"
            self.interval = [0, 1, 5, 10, 30]
        }
        let interval_3 =  UIAlertAction(title: "오늘, 1일, 7일, 15일, 30일", style: .default) {
            (action) in self.intervalLabel.text = "오늘, 1일, 7일, 15일, 30일"
            self.interval = [0, 1, 7, 15, 30]
        }
        let interval_4 =  UIAlertAction(title: "직접입력", style: .default) {
            (action) in
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(interval_1)
        alert.addAction(interval_2)
        alert.addAction(interval_3)
        alert.addAction(interval_4)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
