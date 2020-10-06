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

    mutating func update(isDone: Bool, detail: String, date: String) {
        self.isDone = isDone
        self.detail = detail
        self.date = date
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
        return Todo(id: nextId, isDone: false, detail: detail, date: date)
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodo()
        
        if let count = dateDic[todo.date] {
            dateDic.updateValue(count + 1, forKey: todo.date)
        } else {
            dateDic.updateValue(1, forKey: todo.date)
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos = todos.filter { existingTodo in           // 같은 계획 모두 삭제, 반복 계획만 삭제하는 코드 id != id , progress != progress
            return existingTodo.id != todo.id
        }
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
        saveTodo()
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.jason")
       
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.jason", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
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
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
    
    func todayTodo(_ date: String) {
        manager.todayTodo(date)
    }
}
