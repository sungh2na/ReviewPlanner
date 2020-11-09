//
//  ViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/09/22.
//
import FSCalendar
import UIKit
import UserNotifications


class ReviewPlannerViewController: UIViewController, Edit_1_Delegate, Edit_2_Delegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    let reviewPlannerViewModel = ReviewPlannerViewModel()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    var selectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.locale = Locale(identifier: "ko_KR")
        reviewPlannerViewModel.loadTasks()
        reviewPlannerViewModel.todayTodo(selectedDate)
        dateLabel.text = dateFormatter.string(from: selectedDate)
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        
        setNotification()
    }
    
    func setNotification() {
        let manager = NotificationManager()
        manager.requestPermission()
        manager.addNotification(title: "This is a test reminder")
        manager.schedule(hour: 9, minute: 00)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "showAdd", sender: nil )
    }
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            default:
                return velocity.y < 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAdd" {
            if let secondView = segue.destination as? AddViewController {
                secondView.delegate = self
                secondView.today = selectedDate
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
        var index = 0
        //let interval = [0, 1, 5, 10, 30]
        TodoManager.shared.nextReviewId()
        interval.forEach {
            let dDay = selectedDate.addingTimeInterval(Double($0 * 86400))
            let todo = TodoManager.shared.createTodo(detail: detail, date: dDay, reviewNum: index + 1, reviewTotal: interval.count)
            reviewPlannerViewModel.addTodo(todo)
            index += 1
        }
        reviewPlannerViewModel.todayTodo(selectedDate)
        tableView.reloadData()
        calendar.reloadData()
    }
}

extension ReviewPlannerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showModify", sender: indexPath.row)
    }
    
    func modifytodo(_ todo: Todo) {
        let todayTodo = todo
        self.reviewPlannerViewModel.updateAllTodo(todayTodo)
        self.reviewPlannerViewModel.todayTodo(selectedDate)
        tableView.reloadData()
        self.calendar.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delay = delayAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, delay])
    }
    
    func delayAction(at indexPath: IndexPath) -> UIContextualAction {
        let todayTodo = reviewPlannerViewModel.todayTodos[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Delay") { (action, view, completion) in
            self.reviewPlannerViewModel.delayTodo(todayTodo)
            self.reviewPlannerViewModel.todayTodo(todayTodo.date)
            self.tableView.reloadData()
            self.calendar.reloadData()
            completion(true)
        }
        action.image = UIImage(systemName: "arrow.right")
        action.backgroundColor = .gray
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let todayTodo = reviewPlannerViewModel.todayTodos[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "해당 일정만 삭제", style: .default) {
                (action) in self.reviewPlannerViewModel.deleteTodo(todayTodo)
                self.reviewPlannerViewModel.todayTodo(todayTodo.date)
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
            let deleteAll = UIAlertAction(title: "해당 일정 전체 삭제", style: .default) {
                (action) in self.reviewPlannerViewModel.deleteAllTodo(todayTodo)
                self.reviewPlannerViewModel.todayTodo(todayTodo.date)
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
            let cancel =  UIAlertAction(title: "취소", style: .cancel)

            alert.addAction(delete)
            alert.addAction(deleteAll)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemPink
        return action
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
        todayTodo = reviewPlannerViewModel.todayTodos[indexPath.row]

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
        selectedDate = date
        dateLabel.text = dateFormatter.string(from: selectedDate)
        reviewPlannerViewModel.todayTodo(date)
        tableView.reloadData()
    }
}

extension ReviewPlannerViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {                // 달력에 이벤트 표시
        let dates = reviewPlannerViewModel.getAllDate()
        for getDate in dates {
            let dateString = dateFormatter.string(from: getDate)
            guard let eventDate = dateFormatter.date(from: dateString) else { return 0 }
            if date.compare(eventDate) == .orderedSame {
                return 1
            }
        }
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
        checkButton.isSelected = todo.isDone
        progressLabel.text = "\(todo.reviewNum)/\(todo.reviewTotal)"
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        showStrikeThrough(todo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset() {
        descriptionLabel.alpha = 1
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        doneButtonTapHandler?(isDone)
    }
}

