//
//  SearchViewController.swift
//  ReviewApp
//
//  Created by Y on 2021/03/31.
//

import UIKit
import DeviceKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    let reviewPlannerViewModel = ReviewPlannerViewModel()
    var isDone: Int = 0
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    @IBAction func setIsDone(_ sender: Any) {
        let alert: UIAlertController
        if Device.current.isPad {
            alert = UIAlertController(title:"진행여부 선택", message: "전체 완료 미완료 중 선택", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title:"진행여부 선택", message: "전체 완료 미완료 중 선택", preferredStyle: .actionSheet)
        }
        let isDoneAll = UIAlertAction(title: "전체", style: .default) {
            (action) in self.isDone = 0
            self.searchLabel.text = "전체"
            self.tableView.reloadData()
        }
        let isDoneTrue = UIAlertAction(title: "완료", style: .default) {
            (action) in self.isDone = 1
            self.searchLabel.text = "완료"
            self.tableView.reloadData()
        }
        let isDonefalse = UIAlertAction(title: "미완료", style: .default) {
            (action) in self.isDone = 2
            self.searchLabel.text = "미완료"
            self.tableView.reloadData()
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(isDoneAll)
        alert.addAction(isDoneTrue)
        alert.addAction(isDonefalse)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setSDate(_ sender: Any) {
        let startDateString = startDate.date.toString(format: "yyyy. MM. dd")
        startDate.date = formatter.date(from: startDateString) ?? Date()    // 15:00 으로 설정
        tableView.reloadData()
        
    }
    @IBAction func setEDate(_ sender: Any) {
        let endDateString = endDate.date.toString(format: "yyyy. MM. dd")
        endDate.date = formatter.date(from: endDateString) ?? Date()
        tableView.reloadData()
        endDate.resignFirstResponder()
    }
}



extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewPlannerViewModel.searchTodo(isDone, startDate.date, endDate.date)
        print("###############\(startDate.date), \(endDate.date))")
        return reviewPlannerViewModel.searchTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        var searchTodo: Todo
        searchTodo = reviewPlannerViewModel.searchTodos[indexPath.row]
        print("$$$$$$$$$$$$$\(searchTodo.date)")
        cell.doneButtonTapHandler = { isDone in
            searchTodo.isDone = isDone
            self.reviewPlannerViewModel.saveTasks()
            tableView.reloadData()
        }
        
        cell.updateUI(todo: searchTodo)
        return cell
    }
    
    
}

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var strikeThroughView: UIView!
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
        strikeThroughView.isHidden = !show
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
