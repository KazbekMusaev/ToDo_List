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
}

final class MainInteractor: MainInteractorProtocol {
    private func saveItemsInCoreData(_ items: [ToDoItem]) {
        DispatchQueue.global().async {
            items.forEach { item in
                CoreManager.shared.createData(item: item)
                print("save")
                print(FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!)
            }
        }
    }
    
    func updateItem(_ item: ToDoItem) {
        print("updateItem -> MainInteractor")
        presenter?.reloadItem(item)
    }
    
    weak var presenter: MainPresenterProtocol?
    
    func fetchData() {
        
        let isLoadFirstData = UserDefaults.standard.bool(forKey: "isLoadFirstData")
        if !isLoadFirstData {
            NetworkService.getData { [weak self] result in
                print("load from api")
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
                print("load from core data")
                var model: [ToDoItem] = []
                CoreManager.shared.toDoItems.forEach { item in
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
                self?.presenter?.didLoadTasks(model)
            }
        }
    }
    
}
