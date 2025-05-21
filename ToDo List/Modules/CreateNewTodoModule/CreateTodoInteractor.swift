//
//  CreateTodoInteractor.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol CreateTodoInteractorProtocol: AnyObject {
    func getData()
    func saveTodoInCoreData(label: String?, text: String)
}

final class CreateTodoInteractor: CreateTodoInteractorProtocol {
    weak var presenter: CreateTodoPresenterProtocol?
    
    func saveTodoInCoreData(label: String?, text: String) {
        if !text.isEmpty {
            let maxId = (CoreManager.shared.toDoItems.map { $0.id }.max() ?? 0) + 1
            let maxUserId = (CoreManager.shared.toDoItems.map { $0.userId }.max() ?? 0) + 1
            var labelText: String = ""
            if let label, !label.isEmpty {
                labelText = label
            } else {
                if let firstWord = text.components(separatedBy: " ").first {
                    labelText = firstWord
                } else {
                    labelText = text
                }
            }
            let item = ToDoItem(id: Int(maxId), todo: text, completed: false, userId: Int(maxUserId), date: Date(), label: labelText)
            CoreManager.shared.createData(item: item)
        }
        presenter?.dissmisVC()
    }
    
    func getData() {
        presenter?.showDataInScreen(date: Date(), label: "Заголовок...", text: "Описание...")
    }
    
}
