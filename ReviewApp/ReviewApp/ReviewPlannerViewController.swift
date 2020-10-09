//
//  ViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/09/22.
//
import FSCalendar
import UIKit

class ReviewPlannerViewController: UIViewController, Edit_1_Delegate, Edit_2_Delegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let reviewPlannerViewModel = ReviewPlannerViewModel()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.locale = Locale(identifier: "ko_KR")
        // 데이터 불러오기
        reviewPlannerViewModel.loadTasks()
        reviewPlannerViewModel.todayTodo(dateFormatter.string(from: Date()))
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "showAdd", sender: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAdd" {
            if let secondView = segue.destination as? AddViewController {
                secondView.delegate = self
            }
        } else if segue.identifier == "showModify" {
            if let secondView = segue.destination as? ModifyViewController {
                secondView.delegate = self
                if let index = sender as? Int {
                    var todayTodo: Todo
                    todayTodo = reviewPlannerViewModel.todayTodos[index]
                    secondView.todo = todayTodo
                }
                
            }
        }
    }
    
    func addTaskButtonTapped(_ detail: String, _ interval: [Int]) {
        guard let date = dateLabel.text, date.isEmpty == false else { return }
        let dateFormat = dateFormatter.date(from:date)
        var index = 0
        //let interval = [0, 1, 5, 10, 30]        // interval 입력받기, 위치 수정해줘야 함(id같게)
        TodoManager.shared.nextReviewId()
        interval.forEach {
            if let dDay = dateFormat?.addingTimeInterval(Double($0 * 86400)){
                let todo = TodoManager.shared.createTodo(detail: detail, date: dateFormatter.string(from: dDay), reviewNum: index + 1, reviewTotal: interval.count)
                reviewPlannerViewModel.addTodo(todo)
                index += 1
            }
        }
        reviewPlannerViewModel.todayTodo(date)
        tableView.reloadData()
        calendar.reloadData()
    }
}

extension ReviewPlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showModify", sender: indexPath.row)
    }
    
    func modifytodo(_ todo: Todo) {
        guard let date = dateLabel.text, date.isEmpty == false else { return }
        let todayTodo = todo
        self.reviewPlannerViewModel.updateAllTodo(todayTodo)
        self.reviewPlannerViewModel.todayTodo(date)
        tableView.reloadData()
        self.calendar.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var todayTodo: Todo
        todayTodo = reviewPlannerViewModel.todayTodos[indexPath.item]
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "해당 일정만 삭제", style: .default) {
                (action) in self.reviewPlannerViewModel.deleteTodo(todayTodo)
                self.reviewPlannerViewModel.todayTodo(todayTodo.date)
                tableView.reloadData()
                self.calendar.reloadData()
            }
            let deleteAll = UIAlertAction(title: "해당 일정 전체 삭제", style: .default) {
                (action) in self.reviewPlannerViewModel.deleteAllTodo(todayTodo)
                self.reviewPlannerViewModel.todayTodo(todayTodo.date)
                tableView.reloadData()
                self.calendar.reloadData()
            }
            let cancel =  UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(delete)
            alert.addAction(deleteAll)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .none {
            print("")
        }
    }
}

extension ReviewPlannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewPlannerViewModel.todayTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewPlannerCell", for: indexPath) as? ReviewPlannerCell else {
            return UITableViewCell()
        }
        var todayTodo: Todo
        todayTodo = reviewPlannerViewModel.todayTodos[indexPath.item]

        cell.doneButtonTapHandler = { isDone in
            todayTodo.isDone = isDone
            self.reviewPlannerViewModel.updateTodo(todayTodo)
            self.reviewPlannerViewModel.todayTodo(todayTodo.date)
            tableView.reloadData()
        }
        
        cell.updateUI(todo: todayTodo)
        return cell
    }
}

extension ReviewPlannerViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let date = dateFormatter.string(from: date)
        // 날짜 선택시 발생하는 이벤트!
        dateLabel.text = date
        // 해당 날짜로 필터링
        reviewPlannerViewModel.todayTodo(date)
        tableView.reloadData()
    }
}

extension ReviewPlannerViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {                // 달력에 이벤트 표시
        let dates = reviewPlannerViewModel.getAllDate()
        for getDate in dates {
            guard let eventDate = dateFormatter.date(from: getDate) else { return 0 }
            if date.compare(eventDate) == .orderedSame {
                return 1
            }
        }
//        let datedic = reviewPlannerViewModel.dateDic
//        for (dicDate, count) in datedic {
//            guard let eventDate = dateFormatter.date(from: dicDate) else { return 0 }
//            if date.compare(eventDate) == .orderedSame {
//                return count
//            }
//        }
        return 0
    }
}

class ReviewPlannerCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    @IBOutlet weak var memoButton: UIButton!
    var doneButtonTapHandler: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo) {
        // 셀 업데이트 하기
        checkButton.isSelected = todo.isDone
        progressLabel.text = "\(todo.reviewNum)/\(todo.reviewTotal)"
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        showStrikeThrough(todo.isDone)      // 수정하기
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width     // 줄 보여줘야 할 때
        } else {
            strikeThroughWidth.constant = 0                                 // 줄 감출 때
        }
    }
    
    func reset() {
        descriptionLabel.alpha = 1
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        // checkButton 처리
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)                       // 수정하기
        descriptionLabel.alpha = isDone ? 0.2 : 1
        // 데이터 업데이트
        doneButtonTapHandler?(isDone)
    }
}
