//
//  SearchViewController.swift
//  ReviewApp
//
//  Created by Y on 2021/03/31.
//

import UIKit
import DeviceKit

class SearchViewController: UIViewController {

    let reviewPlannerViewModel = ReviewPlannerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func setIsDone(_ sender: Any) {
        var isDone = false
        let alert: UIAlertController
        if Device.current.isPad {
            alert = UIAlertController(title:"진행여부 선택", message: "전체 완료 미완료 중 선택", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title:"진행여부 선택", message: "전체 완료 미완료 중 선택", preferredStyle: .actionSheet)
        }
        let isDoneAll = UIAlertAction(title: "전체", style: .default) {
            (action) in
        }
        let isDoneTrue = UIAlertAction(title: "완료", style: .default) {
            (action) in isDone = true
        }
        let isDonefalse = UIAlertAction(title: "미완료", style: .default) {
            (action) in isDone = false
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(isDoneAll)
        alert.addAction(isDoneTrue)
        alert.addAction(isDonefalse)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewPlannerViewModel.searchTodo(false)
        print("###############\(reviewPlannerViewModel.searchTodos.count)")
        return reviewPlannerViewModel.searchTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        var searchTodo: Todo
        searchTodo = reviewPlannerViewModel.searchTodos[indexPath.row]

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
