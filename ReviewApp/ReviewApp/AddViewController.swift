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
    @IBOutlet var holidayButton: [UIButton]!
    
    var today: Date?
    var delegate: Edit_1_Delegate?
    var interval = [0, 1, 5, 10, 30]
    var newInterval: [Int] = []
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
            delegate?.addTaskButtonTapped(inputTextField.text!, newInterval)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func setInterval(_ sender: Any) {
//        interval = [0, 1, 5, 10, 30]
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
    
    func createSchedule() {     // 코드 수정
        var intervalString = ""
        var dateString = ""
        var progressString = ""
        let week = ["일", "월", "화", "수", "목", "금", "토"]
        var index = 0
        var delay = 0
        
        schedules.removeAll()
        newInterval = interval
        
        for index in 0 ..< newInterval.count {
            var count = 0
            newInterval[index] += delay
            if let dDay = today?.addingTimeInterval(Double(newInterval[index] * 86400)){
                dateFormatter.dateFormat = "E"
                dateString = dateFormatter.string(from: dDay)
                while holidays.contains(dateString) {       // 모든 요일을 휴일로 선택하면 에러 발생
                    count += 1
                    if let weekIndex = week.firstIndex(of: dateString) {
                        dateString = week[(weekIndex + 1) % week.count]
                    }
                }
            }
            newInterval[index] += count
            delay += count
        }
        
        dateFormatter.dateFormat = "yyyy. MM. dd. E"
        
        newInterval.forEach {
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

    @IBAction func holidayButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            holidays.remove(sender.titleLabel!.text!)
        } else {
            if holidays.count < 6 {
                sender.isSelected = true
                holidays.insert(sender.titleLabel!.text!)   // 수정
            } else { // 모두 휴일로 지정
                let alert = UIAlertController(title: " ", message: "휴일을 지정할 수 없습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        
        self.createSchedule()
        self.tableView.reloadData()
    }
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
}

extension AddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

