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
    var reviewCount : Int
    let reviewId: Int

    mutating func update(isDone: Bool, detail: String, date: String, reviewCount: Int) {
        self.isDone = isDone
        self.detail = detail
        self.date = date
        self.reviewCount = reviewCount
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class TodoManager {
    static let shared = TodoManager()
    static var lastId: Int = 0
    static var reviewId: Int = 0
    var todos: [Todo] = []
    var todayTodos: [Todo] = []
    
    func createTodo(detail: String, date: String, reviewCount: Int) -> Todo {
        let nextId = TodoManager.lastId + 1
        let nextReviewId = TodoManager.reviewId
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail, date: date, reviewCount: reviewCount, reviewId: nextReviewId)
    }
    
    func nextReviewId() {
        TodoManager.reviewId += 1
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        todos = todos.filter { existingTodo in           // 같은 계획 모두 삭제, 반복 계획만 삭제하는 코드 id != id , progress != progress
            return existingTodo.id != todo.id
        }
        saveTodo()
    }
    
    func deleteAllTodo(_ todo: Todo) {
        todos = todos.filter { existingTodo in
            return existingTodo.reviewId != todo.reviewId
        }
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, date: todo.date, reviewCount: todo.reviewCount)
        saveTodo()
    }
    
    func updateAllTodo(_ todo: Todo) {      // 고치고 싶다 ㅠㅠ
        for index in 0 ..< todos.count {
            if todos[index].reviewCount == todo.reviewCount {
                todos[index].update(isDone: todos[index].isDone, detail: todo.detail, date: todos[index].date, reviewCount: todos[index].reviewCount)
            }
        }
        saveTodo()
    }
    func getProgress(_ todo: Todo) -> String {
        var progress = ""
        let SameIdTodos = todos.filter { return $0.reviewId == todo.reviewId }
        guard let index = SameIdTodos.firstIndex(of: todo) else { return "" }
        progress = "\(index + 1)/\(SameIdTodos.count)"
        return progress
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.jason")
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.jason", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
    
    func todayTodo(_ date: String) {
        todayTodos = todos.filter { $0.date == date }
    }
    
    func getAllDate() -> [String] {
        let dates = todos.map{ $0.date }
        return dates
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
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func deleteAllTodo(_ todo: Todo) {
        manager.deleteAllTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func updateAllTodo(_ todo: Todo) {
        manager.updateAllTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
    
    func todayTodo(_ date: String) {
        manager.todayTodo(date)
    }
    
    func getAllDate() -> [String] {
        return manager.getAllDate()
    }
    func getProgress(_ todo: Todo) -> String {
        return manager.getProgress(todo)
    }
}
