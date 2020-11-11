//
//  DaysController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/18.
//

// DB
// weak, unowned
// lazy
// RestAPI
// 오픈소스 SwiftDate 사용법 익히기
// ARC(Auto Reference Counting)
// 클로저의 정의

// 가비지컬렉터

// A
// A -> B

// 1 2 -> 0
// A -> B
// 0    1
// A <- B
// 1    1
// C -> A, B
// 2    2
// C버림
// 1    1
// A <--> B
// A <--} B
// 1     0

import Foundation
import UIKit

protocol Edit_3_Delegate: class {
    func storedDays(_ days: [Int])
}

class DaysController : UITableViewController {
    var storedDays: [Int]?
    var days: [Int] = [0]
    weak var delegate: Edit_3_Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let storedDays = self.storedDays else { return }
        days = storedDays
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = days.contains(indexPath.row) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = days.firstIndex(of: indexPath.row) {
            days.remove(at: index)
        } else {
            days.append(indexPath.row)
        }
        delegate?.storedDays(days)
        tableView.reloadData()
    }
}

//class A {
//
//    var a: () -> Void = { [weak self] in
//        self.test()
//    }
//
//    func test() {
//
//    }
//}

// 둘다 약한참조 만들어주는데 weak은 nil은반환하고 unowned는 crash가 나서 확실때 쓴다.
// 서로 강한 참조가 발생해서 레퍼런스 카운트가 서로 1일때 하나를 weak으로 해주면 레퍼런스 카운트가 0으로 되어서 참조하는 객체가 사라지고

// 정의를 먼저 확실하게 말하기
// 그 객체가 사라지니까 참조하고있던 객체도사라짐.
// 강한참조, 약한참조 레퍼런스 싸이클 생겼을때 weak unowned를 사용하게됨.
