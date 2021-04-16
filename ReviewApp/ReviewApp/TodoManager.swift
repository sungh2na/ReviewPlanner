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
    var searchTodos: [Todo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var container = appDelegate.persistentContainer
    lazy var context = container.viewContext
    let request: NSFetchRequest<Todo> = Todo.fetchRequest()
    
    init() {
        do {
            let initRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            initRequest.fetchLimit = 1
            initRequest.sortDescriptors = [
                NSSortDescriptor(key: "id", ascending: false)
            ]
            let maxID = try context.fetch(initRequest).first?.id ?? 0
            TodoManager.lastId = Int(maxID)
            TodoManager.reviewId = Int(maxID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
        // 한번에 삭제하는 법 찾아보기
        let deletedTodo = try! context.fetch(request)
        deletedTodo.forEach {
            context.delete($0)
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
        return (try? context.fetch(request))?.isEmpty ?? true
    }
    
    func searchTodo(_ isDone: Int, _ startDate: Date, _ endDate: Date) {   // all, true, false
//        request.predicate = NSPredicate(format: "isDone == %@", isDone)
//        request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: isDone))
//        request.fetchLimit = .max
//        searchTodos = try! context.fetch(request)
//        request.predicate = nil
//        request.fetchLimit = .max
//        context.fetch(request)
        switch isDone {
        case 1:
            request.predicate = NSPredicate(format: "isDone == %@ && date >= %@ && date <= %@", NSNumber(value: true), startDate as NSDate, endDate as NSDate)
            request.fetchLimit = .max
            searchTodos = try! context.fetch(request)
        case 2:
            request.predicate = NSPredicate(format: "isDone == %@ && date >= %@ && date <= %@", NSNumber(value: false), startDate as NSDate, endDate as NSDate)
            request.fetchLimit = .max
            searchTodos = try! context.fetch(request)
        default:
//            request.predicate = nil
            request.predicate = NSPredicate(format: "date >= %@ && date <= %@", startDate as NSDate, endDate as NSDate)
            request.fetchLimit = .max
            searchTodos = try! context.fetch(request)
        }
    }
}

class ReviewPlannerViewModel {
    private let manager = TodoManager.shared
    
    var todayTodos: [Todo] {
        return manager.todayTodos
    }
    
    var searchTodos: [Todo] {
        return manager.searchTodos
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
    
    func searchTodo(_ isDone: Int, _ startDate: Date, _ endDate: Date) {
        manager.searchTodo(isDone, startDate, endDate)
    }

    func isEmpty(date: Date) -> Bool {
        return manager.isEmpty(date: date)
    }
    
}

