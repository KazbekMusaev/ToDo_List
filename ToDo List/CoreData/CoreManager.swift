//
//  CoreManager.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation
import CoreData

final class CoreManager {
    static let shared = CoreManager()
    var toDoItems = [ToDoCDItem]()
    
    private init() {
        readData()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo_List")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(item: ToDoItem) {
        let createData = ToDoCDItem(context: persistentContainer.viewContext)
        createData.id = Int32(item.id)
        createData.userId = Int32(item.userId)
        createData.date = item.date
        createData.label = item.label
        createData.isCompleted = item.completed
        createData.text = item.todo
        saveContext()
        readData()
    }
    
    func readData() {
        let toDoItems = ToDoCDItem.fetchRequest()
        if let toDoItems = try? persistentContainer.viewContext.fetch(toDoItems) {
            self.toDoItems = toDoItems
        }
    }
}

extension CoreManager {
    static func filtredData(_ data: [ToDoCDItem]) -> [ToDoItem] {
        var model: [ToDoItem] = []
        data.forEach { item in
            let toDoItem = ToDoItem(
                id: Int(item.id),
                todo: item.text ?? "nill",
                completed: item.isCompleted,
                userId: Int(item.userId),
                date: item.date,
                label: item.label
            )
            model.append(toDoItem)
        }
        return model
    }
}
