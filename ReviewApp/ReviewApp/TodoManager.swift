//
//  Todo.swift
//  ReviewApp
//
//  Created by Y on 2020/09/23.
//

import UIKit
import CoreData

class TodoManager {
    static let shared = TodoManager()
    static var lastId: Int = 0
    static var reviewId: Int = 0
    var todayTodos: [Todo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var container = appDelegate.persistentContainer
    lazy var context = container.viewContext
    let request: NSFetchRequest<Todo> = Todo.fetchRequest()
    
    func nextReviewId() {
        TodoManager.reviewId += 1
    }
    
    func addTodo(detail: String, date: Date, reviewNum: Int, reviewTotal: Int) {
        let nextId = TodoManager.lastId + 1
        let nextReviewId = TodoManager.reviewId
        TodoManager.lastId = nextId
        
        let todo = Todo(context: context)
        todo.id = Int16(nextId)
        todo.isDone = false
        todo.detail = detail
        todo.date = date
        todo.reviewId = Int16(nextReviewId)
        todo.reviewNum = Int16(reviewNum)
        todo.reviewTotal = Int16(reviewTotal)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        context.delete(todo)
        setProgress(todo)
        saveTodo()
    }
    
    func deleteAllTodo(_ todo: Todo) {
        let reviewId = todo.reviewId
        request.fetchLimit = Int(todo.reviewTotal)
        request.predicate = NSPredicate(format: "reviewId == %d", reviewId)
        // 질문하기
        let deletedTodo = try! context.fetch(request)
        deletedTodo.forEach {
            let object = context.object(with: $0.objectID)
            context.delete(object)
        }
        saveTodo()
    }
    
    func delayTodo(_ todo: Todo) {
        let today = todo.date
        let tomorrow = today?.addingTimeInterval(Double(86400))
        todo.date = tomorrow
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        request.fetchLimit = Int(todo.reviewTotal)
        request.predicate = NSPredicate(format: "reviewId == %d", todo.reviewId)
        let todos = try! context.fetch(request)
        todos.forEach {
            $0.detail = todo.detail
        }
        saveTodo()
    }
    
    func setProgress(_ todo: Todo) {
        request.fetchLimit = Int(todo.reviewNum) - 1
        request.predicate = NSPredicate(format: "reviewId == %d AND reviewNum < %d", todo.reviewId, todo.reviewNum)
        var todos = try! context.fetch(request)
        todos.forEach {
            $0.reviewTotal -= 1
        }
        
        request.fetchLimit = Int(todo.reviewTotal - todo.reviewNum)
        request.predicate = NSPredicate(format: "reviewId == %d AND reviewNum > %d", todo.reviewId, todo.reviewNum)
        todos = try! context.fetch(request)
        todos.forEach {
            $0.reviewNum -= 1
            $0.reviewTotal -= 1
        }
    }
    
    func saveTodo() {
        print("home: \(NSHomeDirectory())")
        try! context.save()
    }
    
    func todayTodo(_ date: Date) {
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        request.fetchLimit = .max
        todayTodos = try! context.fetch(request)
    }
    
    func isEmpty(date: Date) -> Bool {
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        request.fetchLimit = 1
        return !((try? context.fetch(request))?.isEmpty ?? true)
    }
}

class ReviewPlannerViewModel {
    private let manager = TodoManager.shared
    
    var todayTodos: [Todo] {
        return manager.todayTodos
    }

    func addTodo(detail: String, date: Date, reviewNum: Int, reviewTotal: Int) {
        manager.addTodo(detail: detail, date: date, reviewNum: reviewNum, reviewTotal: reviewTotal)
    }

    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }

    func deleteAllTodo(_ todo: Todo) {
        manager.deleteAllTodo(todo)
    }
    
    func delayTodo(_ todo: Todo) {
        manager.delayTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func saveTasks() {
        manager.saveTodo()
    }

    func todayTodo(_ date: Date) {
        manager.todayTodo(date)
    }

    func isEmpty(date: Date) -> Bool {
        return manager.isEmpty(date: date)
    }
}
