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
    var date: Date
    let reviewId: Int
    var reviewNum: Int
    var reviewTotal: Int

    mutating func update(isDone: Bool, detail: String, date: Date, reviewNum: Int, reviewTotal: Int) {
        self.isDone = isDone
        self.detail = detail
        self.date = date
        self.reviewNum = reviewNum
        self.reviewTotal = reviewTotal
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
    
    func createTodo(detail: String, date: Date, reviewNum: Int, reviewTotal: Int) -> Todo {
        let nextId = TodoManager.lastId + 1
        let nextReviewId = TodoManager.reviewId
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail, date: date, reviewId: nextReviewId, reviewNum: reviewNum, reviewTotal: reviewTotal)
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
        setProgress(todo)
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
        todos[index].update(isDone: todo.isDone, detail: todo.detail, date: todo.date, reviewNum: todo.reviewNum, reviewTotal: todo.reviewTotal)
        saveTodo()
    }
    
    func updateAllTodo(_ todo: Todo) {      // 고치고 싶다 ㅠㅠ, 같은 계획 모두 수정
        for index in 0 ..< todos.count {
            if todos[index].reviewId == todo.reviewId {
                todos[index].update(isDone: todos[index].isDone, detail: todo.detail, date: todos[index].date, reviewNum: todos[index].reviewNum, reviewTotal: todos[index].reviewTotal)
            }
        }
        saveTodo()
    }
    func setProgress(_ todo: Todo) {        // 흐으으음... ㅠㅠ
        for index in 0 ..< todos.count {
            if todos[index].reviewId == todo.reviewId {
                if todos[index].reviewNum < todo.reviewNum {
                    todos[index].update(isDone: todos[index].isDone, detail: todos[index].detail, date: todos[index].date, reviewNum: todos[index].reviewNum, reviewTotal: todos[index].reviewTotal - 1)
                } else {
                    todos[index].update(isDone: todos[index].isDone, detail: todos[index].detail, date: todos[index].date, reviewNum: todos[index].reviewNum - 1, reviewTotal: todos[index].reviewTotal - 1)
                }
            }
        }
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todos.jason")
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.jason", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        let reviewId = todos.last?.reviewId ?? 0
        TodoManager.lastId = lastId
        TodoManager.reviewId = reviewId
    }
    
    func todayTodo(_ date: Date) {
        todayTodos = todos.filter { $0.date == date }
    }
    
    func getAllDate() -> [Date] {
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
    
    func todayTodo(_ date: Date) {
        manager.todayTodo(date)
    }
    
    func getAllDate() -> [Date] {
        return manager.getAllDate()
    }
}
