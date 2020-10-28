//
//  AddViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/03.
//

import UIKit

protocol Edit_1_Delegate{
    func addTaskButtonTapped(_ detail: String, _ interval: [Int])
}

class AddViewController: UIViewController, Edit_4_Delegate {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: Edit_1_Delegate?
    var interval = [0, 1, 5, 10, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserInput" {
            if let secondView = segue.destination as? UserInputController {
                secondView.delegate = self
            }
        }
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
            (action) in self.performSegue(withIdentifier: "showUserInput", sender: nil)
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(interval_1)
        alert.addAction(interval_2)
        alert.addAction(interval_3)
        alert.addAction(interval_4)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func userInputButtonTapped(_ interval: [Int]) {
        self.interval = interval
        self.intervalLabel.text = interval.map {
            if $0 == 0 {
                return "오늘"
            } else {
                return ", \($0)일"
            }
        }.joined()
    }
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
}

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reviewPlannerViewModel.todayTodos.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
//        var todayTodo: Todo
//        todayTodo = reviewPlannerViewModel.todayTodos[indexPath.item]
//
//        cell.doneButtonTapHandler = { isDone in
//            todayTodo.isDone = isDone
//            self.reviewPlannerViewModel.updateTodo(todayTodo)
//            self.reviewPlannerViewModel.todayTodo(todayTodo.date)
//            tableView.reloadData()
//        }
//
//        cell.updateUI(todo: todayTodo)
        return cell
    }
    
}

class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    func updateUI(todo: Todo) {
        // 셀 업데이트 하기
//        checkButton.isSelected = todo.isDone
//        progressLabel.text = "\(todo.reviewNum)/\(todo.reviewTotal)"
//        descriptionLabel.text = todo.detail
//        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
//        showStrikeThrough(todo.isDone)      // 수정하기
    }
    
}
