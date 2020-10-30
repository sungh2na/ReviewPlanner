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
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var monButton: UIButton!
    @IBOutlet weak var tueButton: UIButton!
    @IBOutlet weak var wedButton: UIButton!
    @IBOutlet weak var thuButton: UIButton!
    @IBOutlet weak var friButton: UIButton!
    @IBOutlet weak var satButton: UIButton!
    
    
    
    var today: Date?
    var delegate: Edit_1_Delegate?
    var interval = [0, 1, 5, 10, 30]
    var holidays: Set<String> = []
    var schedules: [Schedule] = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSchedule()
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
            (action) in self.interval = [0, 1, 3, 7, 15]
            self.userInputButtonTapped(self.interval)
        }
        let interval_2 =  UIAlertAction(title: "오늘, 1일, 5일, 10일, 20일", style: .default) {
            (action) in self.interval = [0, 1, 5, 10, 20]
            self.userInputButtonTapped(self.interval)
        }
        let interval_3 =  UIAlertAction(title: "오늘, 1일, 7일, 15일, 30일", style: .default) {
            (action) in self.interval = [0, 1, 7, 15, 30]
            self.userInputButtonTapped(self.interval)
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
        self.createSchedule()
        self.tableView.reloadData()
    }
    
    func createSchedule() {
        schedules.removeAll()
        var intervalString = ""
        var dateString = ""
        var progressString = ""
        var index = 0
        interval = interval.map
        interval.forEach {
            if $0 == 0 {
                intervalString = "오늘"
            } else {
                intervalString = "\($0)일"
            }
            
            if let dDay = today?.addingTimeInterval(Double($0 * 86400)){
                dateString = dateFormatter.string(from: dDay)
            }
            progressString = "\(index + 1)/\(interval.count)"
            index += 1
            let schedule = Schedule(interval: intervalString, date: dateString, progress: progressString)
            schedules.append(schedule)
        }
    }
    
    @IBAction func sunButtonTapped(_ sender: Any) {
        if sunButton.isSelected {
            sunButton.isSelected = false
            holidays.remove("일")
        } else {
            sunButton.isSelected = true
            holidays.insert("일")
        }
    }
    @IBAction func monButtonTapped(_ sender: Any) {
        if monButton.isSelected {
            monButton.isSelected = false
            holidays.remove("월")
        } else {
            monButton.isSelected = true
            holidays.insert("월")
        }
    }
    @IBAction func tueButtonTapped(_ sender: Any) {
        if tueButton.isSelected {
            tueButton.isSelected = false
            holidays.remove("화")
        } else {
            tueButton.isSelected = true
            holidays.insert("화")
        }
    }
    @IBAction func wedButtonTapped(_ sender: Any) {
        if wedButton.isSelected {
            wedButton.isSelected = false
            holidays.remove("수")
        } else {
            wedButton.isSelected = true
            holidays.insert("수")
        }
    }
    @IBAction func thuButtonTapped(_ sender: Any) {
        if thuButton.isSelected {
            thuButton.isSelected = false
            holidays.remove("목")
        } else {
            thuButton.isSelected = true
            holidays.insert("목")
        }
    }
    @IBAction func friButtonTapped(_ sender: Any) {
        if friButton.isSelected {
            friButton.isSelected = false
            holidays.remove("금")
        } else {
            friButton.isSelected = true
            holidays.insert("금")
        }
    }
    @IBAction func satButtonTapped(_ sender: Any) {
        if satButton.isSelected {
            satButton.isSelected = false
            holidays.remove("토")
        } else {
            satButton.isSelected = true
            holidays.insert("토")
        }
    }
    
    
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
}

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reviewPlannerViewModel.todayTodos.count
        return interval.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        cell.updateUI(schedule: schedules[indexPath.row])
        return cell
    }
}

struct Schedule {
    var interval: String
    var date: String
    var progress: String
}


class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    func updateUI(schedule: Schedule) {
        intervalLabel.text = schedule.interval
        dateLabel.text = schedule.date
        progressLabel.text = schedule.progress
    }
}

