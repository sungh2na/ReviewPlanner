//
//  Todo.swift
//  ReviewApp
//
//  Created by Y on 2020/09/23.
//

import UIKit


struct Todo: Codable, Equatable {
    let id: Int
    var isDone: Bool
    var detail: String
    var date: String
//    var isToday: Bool       // isToday 대신 날짜 받아와서 해당 날짜에 등록...? 훔...

    mutating func update(isDone: Bool, detail: String, date: String) {
        self.isDone = isDone
        self.detail = detail
        self.date = date
//        self.isToday = isToday
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class TodoManager {
    
    static let shared = TodoManager()
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    var todayTodos: [Todo] = []
    var dateDic: Dictionary<String, Int> = [:]
    
    func createTodo(detail: String, date: String) -> Todo {
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        todayTodo(date)
        return Todo(id: nextId, isDone: false, detail: detail, date: date)
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        todayTodo(todo.date)
        saveTodo()
        
        if let count = dateDic[todo.date] {
            dateDic.updateValue(count + 1, forKey: todo.date)
        } else {
            dateDic.updateValue(1, forKey: todo.date)
        }
        
//        guard let count = dateDic[todo.date] else {
//            dateDic.updateValue(1, forKey: todo.date)
//            return
//        }
//        dateDic.updateValue(count + 1, forKey: todo.date)
    }
    
    func deleteTodo(_ todo: Todo) {
        todos = todos.filter { existingTodo in           // 같은 계획 모두 삭제, 반복 계획만 삭제하는 코드 id != id , progress != progress
            return existingTodo.id != todo.id
        }
        todayTodo(todo.date)
        saveTodo()
        if let count = dateDic[todo.date], count > 1 {
            dateDic.updateValue(count - 1, forKey: todo.date)
        } else {
            dateDic.removeValue(forKey: todo.date)
        }
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, date: todo.date)
        todayTodo(todo.date)
        saveTodo()
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.jason")
       
    }
    
    func retrieveTodo(_ date: String) {
        todos = Storage.retrive("todos.jason", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
        todayTodo(date)
        todos.forEach {
            if let count = dateDic[$0.date] {
                dateDic.updateValue(count + 1, forKey: $0.date)
            } else {
                dateDic.updateValue(1, forKey: $0.date)
            }
        }
    }
    
    func todayTodo(_ date: String) {
        todayTodos = todos.filter { $0.date == date }
    }
}

class ReviewPlannerViewModel {
    
//    enum Section: Int, CaseIterable {
//        case today
//        case upcoming  // 이걸 다른 날짜에 어떻게 넘겨줄까?
//
//        var title: String {
//            switch self {
//                case .today: return "Today"
//                default: return "Upcoming"
//            }
//        }
//    }
    private let manager = TodoManager.shared
    var todos: [Todo] {
        return manager.todos
    }
    
    var todayTodos: [Todo] {
        return manager.todayTodos
    }
    var dateDic: Dictionary<String, Int> {
        return manager.dateDic
    }
        //["2020-10-22":1, "2020-10-23":2, "2020-10-25":3]
//    var todayTodos: [Todo] {                        // 해당 날짜에 해당하는 todo를 필터링 하도록 만들기...
//        return todos.filter { $0.isToday == true }
//    }
    
//    var upcomingTodos: [Todo] {
//        return todos.filter { $0.isToday == false }
//    }
    
//    var numOfSection: Int {
//        return Section.allCases.count
//    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTasks(_ date: String) {
        manager.retrieveTodo(date)
    }
    
    func todayTodo(_ date: String) {
        manager.todayTodo(date)
    }
   
}
