//
//  ToDoModel.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

struct ToDoModel: Decodable {
    let todos: [ToDoItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDoItem: Decodable {
    let id: String
    let todo: String
    let completed: Bool
    let userId: Int
}
