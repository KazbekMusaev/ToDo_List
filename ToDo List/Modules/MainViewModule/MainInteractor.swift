//
//  MainInteractor.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

protocol MainInteractorProtocol {
    func fetchData()
    func updateItem(_ item: ToDoItem)
    func searchToDos(_ text: String)
    func getUpdateData()
    func deleteItem(_ item: ToDoItem)
}

final class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol?
    
    func fetchData() {
        
        let isLoadFirstData = UserDefaults.standard.bool(forKey: "isLoadFirstData")
        if !isLoadFirstData {
            NetworkService.getData { [weak self] result in

                guard let self else { return }
                switch result {
                case .success(let todoData):
                    
                    let filtred = todoData.todos.map { todo in
                        var updated = todo
                        updated.date = Date()
                        updated.label = todo.todo.components(separatedBy: " ").first
                        return updated
                    }
                    
                    UserDefaults.standard.set(true, forKey: "isLoadFirstData")
                    self.saveItemsInCoreData(filtred)
                    self.presenter?.didLoadTasks(filtred)
                    
                case .failure(let error):
                    UserDefaults.standard.set(false, forKey: "isLoadFirstData")
                    self.presenter?.getError(error)
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                self?.presenter?.didLoadTasks(CoreManager.filtredData(CoreManager.shared.toDoItems))
            }
        }
    }
    
    func getUpdateData() {
        DispatchQueue.global().async { [weak self] in
            self?.presenter?.updateCollectionView(CoreManager.filtredData(CoreManager.shared.toDoItems))
        }
    }
    
    func searchToDos(_ text: String) {
        DispatchQueue.global().async { [weak self] in
            if text.isEmpty, text == "" {
                self?.presenter?.searchIsComplete(CoreManager.filtredData(CoreManager.shared.toDoItems))
            } else {
                let result = CoreManager.shared.toDoItems.filter { $0.text?.range(of: text, options: .caseInsensitive) != nil }
                self?.presenter?.searchIsComplete(CoreManager.filtredData(result))
            }
        }
    }
    
    private func saveItemsInCoreData(_ items: [ToDoItem]) {
        DispatchQueue.global().async {
            items.forEach { item in
                CoreManager.shared.createData(item: item)
            }
        }
    }
    
    func updateItem(_ item: ToDoItem) {
        DispatchQueue.global().async { [weak self] in
            guard let index = CoreManager.shared.toDoItems.firstIndex(where: { $0.id == item.id }) else { return }
            CoreManager.shared.toDoItems[index].updateData(newItem: item)
            self?.presenter?.reloadItem(item)
        }
    }
    
    func deleteItem(_ item: ToDoItem) {
        DispatchQueue.global().async { [weak self] in
            guard let index = CoreManager.shared.toDoItems.firstIndex(where: { $0.id == item.id }) else {
                return }
            CoreManager.shared.toDoItems[index].deleteData()
            self?.presenter?.itemIsDeleted(item)
        }
    }
    
}
