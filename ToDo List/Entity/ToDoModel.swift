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
    let id: Int
    //Эти 2 свойства в дальнейшем должны меняться. Меняю на var
    var todo: String
    var completed: Bool
    
    let userId: Int
    //Добавляю дату, после первой загрузки из Api, поставлю сюда текущую дату, т.е сегодня. Дальше хочу использовать эту же модель и в CoreData
    var date: Date?
    //Использую для отображения лейбла, если его не будет, то буду брать первое слово из todo в апи. А также при создании новой заметки, будет подставляться первое слово, если поле заголовка не будет заполнено
    var label: String?
}
