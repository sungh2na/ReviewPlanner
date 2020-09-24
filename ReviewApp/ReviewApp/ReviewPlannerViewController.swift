//
//  ViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/09/22.
//
import FSCalendar
import UIKit

class ReviewPlannerViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reviewPlannerViewModel = ReviewPlannerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        reviewPlannerViewModel.loadTasks()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
        // 날짜 선택시 발생하는 이벤트!
    }

}

//extension ReviewPlannerViewController {
//    @objc private func adjustInputView(noti: Notification) {
//        guard let userInfo = noti.userInfo else { return }
//        // 키보드 높이에 따른 인풋뷰 위치 변경
//    }
//}

extension ReviewPlannerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 섹션 몇개
        return reviewPlannerViewModel.numOfSection
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 섹션별 아이템 몇개
        if section == 0 {       // Today
            return reviewPlannerViewModel.todayTodos.count
        } else {                // upcoming
            return reviewPlannerViewModel.upcomingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 커스텀 셀
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewPlannerCell", for: indexPath) as? ReviewPlannerCell else {
            return UICollectionViewCell()
        }
        
        var todo: Todo
        todo = reviewPlannerViewModel.todayTodos[indexPath.item]
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

class ReviewPlannerCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!  // 이것도 받아야함. 나중에 추가
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView! // 할일 미뤘을 때.
    
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    @IBOutlet weak var modifyButton: UIButton!
    
    var doneButtonTapHandler: (() -> Void)?
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
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
}
