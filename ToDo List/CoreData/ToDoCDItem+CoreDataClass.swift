//
//  ToDoCDItem+CoreDataClass.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//
//

import Foundation
import CoreData

@objc(ToDoCDItem)
public class ToDoCDItem: NSManagedObject {

}

extension ToDoCDItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoCDItem> {
        return NSFetchRequest<ToDoCDItem>(entityName: "ToDoCDItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var userId: Int32
    @NSManaged public var text: String?
    @NSManaged public var label: String?

}

extension ToDoCDItem : Identifiable {
    func updateData (newItem: ToDoItem) {
        self.date = newItem.date
        self.label = newItem.label
        self.isCompleted = newItem.completed
        self.text = newItem.todo
        //id и userId Должны остаться неизменными
        try? managedObjectContext?.save()
    }
    
    func deleteData () {
        managedObjectContext?.delete(self)
        let cManager = CoreManager.shared
        cManager.readData()
        try? managedObjectContext?.save()
    }

}
