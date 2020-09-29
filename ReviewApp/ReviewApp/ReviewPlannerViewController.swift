//
//  ViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/09/22.
//
import FSCalendar
import UIKit

class ReviewPlannerViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
//    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    let reviewPlannerViewModel = ReviewPlannerViewModel()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 키보드 디렉션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        // 데이터 불러오기
        reviewPlannerViewModel.loadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    @IBAction func isTodayButtonTapped(_ sender: Any) {
//        isTodayButton.isSelected = !isTodayButton.isSelected
//    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        guard let date = dateLabel.text, date.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(detail: detail, date: date)
        reviewPlannerViewModel.addTodo(todo)
        collectionView.reloadData()     // 날짜별로 어떻게 컬렉션 뷰 만들지 생각해보기
        inputTextField.text = ""
//        isTodayButton.isSelected = false
    }
    
    // BG 탭했을 때, 키보드 내려오게 하기
//    @IBAction func tapBG(_ sender: Any) {
//        inputTextField.resignFirstResponder()
//    }
}

extension ReviewPlannerViewController: UICollectionViewDataSource {
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // 섹션 몇개
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 섹션별 아이템 몇개
        return reviewPlannerViewModel.todos.count
//        if section == 0 {       // Today
//            return reviewPlannerViewModel.todayTodos.count
//        } else {                // upcoming
//            return reviewPlannerViewModel.upcomingTodos.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 커스텀 셀
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewPlannerCell", for: indexPath) as? ReviewPlannerCell else {
            return UICollectionViewCell()
        }
        
        var todo: Todo
        todo = reviewPlannerViewModel.todos[indexPath.item]
//        if indexPath.section == 0 {
//            todo = reviewPlannerViewModel.todayTodos[indexPath.item]
//        } else {
//            todo = reviewPlannerViewModel.upcomingTodos[indexPath.item]
//        }
        
        
    //    var todayTodos: [Todo] {                        // 해당 날짜에 해당하는 todo를 필터링 하도록 만들기...
    //        return todos.filter { $0.isToday == true }
    //    }
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.reviewPlannerViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.reviewPlannerViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.updateUI(todo: todo)
        return cell
    }
}

extension ReviewPlannerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 사이즈 계산하기
        let width:CGFloat = collectionView.bounds.width
        let height:CGFloat = 40
        return CGSize(width: width, height: height)
    }
}

extension ReviewPlannerViewController: FSCalendarDelegate {
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

//        dateFormatter.dateFormat = "EEE MM.dd"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: date)
//        let dateArr = date.components(separatedBy: " ")
//
//        switch dateArr[0] {
//        case "Mon":
//            date = dateArr[1] + " 월"
//        case "Tue":
//            date = dateArr[1] + " 화"
//        case "Wed":
//            date = dateArr[1] + " 수"
//        case "Thu":
//            date = dateArr[1] + " 목"
//        case "Fri":
//            date = dateArr[1] + " 금"
//        case "Sat":
//            date = dateArr[1] + " 토"
//        case "Sun":
//            date = dateArr[1] + " 일"
//        default:
//            date = date + ""
//        }
        // 날짜 선택시 발생하는 이벤트!
        dateLabel.text = date
        
        // 해당 날짜로 필터링
        reviewPlannerViewModel.todayTodo(date)
        
        collectionView.reloadData()
    }
}

extension ReviewPlannerViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let eventDate = dateFormatter.date(from: "2020-09-22") else { return 0 }
        if date.compare(eventDate) == .orderedSame {
            return 2
        }
        return 0
    }
//       func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        switch dateFormatter.string(from: date) {
//        case dateFormatter.string(from: Date()):
//            return "오늘"
//        case "2020-09-10":
//            return "출근"
//        case "2020-09-11":
//            return "지각"
//        case "2020-09-12":
//            return "결근"
//        default:
//            return nil
//        }
//    }
}


class ReviewPlannerCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!  // 이것도 받아야함. 나중에 추가
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView! // 할일 미뤘을 때.
    
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    @IBOutlet weak var modifyButton: UIButton!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
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
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        deleteButton.isHidden = todo.isDone  == false
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
        deleteButton.isHidden = true
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        // checkButton 처리
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)                       // 수정하기
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        
        // 데이터 업데이트
        doneButtonTapHandler?(isDone)
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteButtonTapHandler?()
    }
}
