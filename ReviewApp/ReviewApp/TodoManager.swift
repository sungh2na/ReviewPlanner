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
    var Todos: [Todo] = []
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
        retrieveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        let object = context.object(with: todo.objectID)
        context.delete(object)
        setProgress(todo)
        saveTodo()
        retrieveTodo()
    }
    
    func deleteAllTodo(_ todo: Todo) {
        let reviewId = todo.reviewId
        let predicate = NSPredicate(format: "reviewId == %d", reviewId)
        request.predicate = predicate
        // 질문하기
        let deletedTodo = try! context.fetch(request)
        deletedTodo.forEach {
            let object = context.object(with: $0.objectID)
            context.delete(object)
        }
        saveTodo()
        retrieveTodo()
    }
    
    func delayTodo(_ todo: Todo) {
        let today = todo.date
        let tomorrow = today?.addingTimeInterval(Double(86400))
        todo.date = tomorrow
        saveTodo()
        retrieveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        let predicate = NSPredicate(format: "reviewId == %d", todo.reviewId)
        request.predicate = predicate
        var todos = try! context.fetch(request)
        todos = todos.map{
            $0.detail = todo.detail
            return $0
        }
        saveTodo()
        retrieveTodo()
    }
    
    func setProgress(_ todo: Todo) {
        let reviewId = todo.reviewId
        let reviewNum = todo.reviewNum
        var predicate = NSPredicate(format: "reviewId == %d AND reviewNum < %d", reviewId, reviewNum)
        request.predicate = predicate
        var todos = try! context.fetch(request)
        todos = todos.map{
            $0.reviewTotal = $0.reviewTotal - 1
            return $0
        }
        predicate = NSPredicate(format: "reviewId == %d AND reviewNum >= %d", reviewId, reviewNum)
        request.predicate = predicate
        todos = try! context.fetch(request)
        todos = todos.map{
            $0.reviewNum = $0.reviewNum - 1
            $0.reviewTotal = $0.reviewTotal - 1
            return $0
        }
    }
    
    func saveTodo() {
        print("home: \(NSHomeDirectory())")
        try! context.save()
    }
    
    func retrieveTodo() {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        self.Todos = try! context.fetch(request)
    }
    
    func todayTodo(_ date: Date) {
        let newDate = date as NSDate
        let yesterday = newDate.addingTimeInterval(-86400)
        let tomorrow = newDate.addingTimeInterval(86400)
        let predicate = NSPredicate(format: "%@ < date And date < %@", yesterday, tomorrow)
        request.predicate = predicate
        todayTodos = try! context.fetch(request)
    }
    
    func getAllDate() -> [Date?] {
        let dates = Todos.map{ return $0.date }
        return dates
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
    
    func loadTasks() {
        manager.retrieveTodo()
    }
    
    func saveTasks() {
        manager.saveTodo()
    }

    func todayTodo(_ date: Date) {
        manager.todayTodo(date)
    }
    
    func getAllDate() -> [Date?] {
        return manager.getAllDate()
    }
}
