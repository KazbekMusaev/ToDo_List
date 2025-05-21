//
//  EditTodoInteractor.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol EditTodoInteractorProtocol: AnyObject {
    func getData()
    func updateDataInCoreData(label: String?, text: String)
}

final class EditTodoInteractor: EditTodoInteractorProtocol {
    weak var presenter: EditTodoPresenterProtocol?
    
    let item: ToDoItem
    
    init(item: ToDoItem) {
        self.item = item
    }
    
    func updateDataInCoreData(label: String?, text: String) {
        guard let index = CoreManager.shared.toDoItems.firstIndex(where: { $0.id == self.item.id }) else { return }
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
        let newData = ToDoItem(id: item.id, todo: text, completed: item.completed, userId: item.userId, date: item.date, label: labelText)
        CoreManager.shared.toDoItems[index].updateData(newItem: newData)
        presenter?.dissmisVC(newData)
    }
    
    func getData() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.presenter?.showDataInScreen(
                date: self.item.date ?? Date(),
                label: self.item.label ?? "Заголовок...",
                text: self.item.todo)
        }
    }
    
}
