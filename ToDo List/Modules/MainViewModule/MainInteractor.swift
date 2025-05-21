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
    func updateItem(_ item: ToDoItem) {
        print("updateItem -> MainInteractor")
        presenter?.reloadItem(item)
    }
    
    weak var presenter: MainPresenterProtocol?
    
    func fetchData() {
        
        let isLoadFirstData = UserDefaults.standard.bool(forKey: "isLoadFirstData")
        if isLoadFirstData {
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
                    self.presenter?.didLoadTasks(filtred)
                case .failure(let error):
                    UserDefaults.standard.set(false, forKey: "isLoadFirstData")
                    self.presenter?.getError(error)
                }
            }
        }
    }
    
    
    private func saveToCoreData(_ items: [ToDoItem]) {
        // Core Data save logic здесь
    }
}
