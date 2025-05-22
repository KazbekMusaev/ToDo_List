//
//  EditTodoPresenter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol EditTodoPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func showDataInScreen(date: Date, label: String, text: String)
    func updateTodo(label: String?, text: String)
    func dissmisVC(_ editItem: ToDoItem)
}

final class EditTodoPresenter {
    weak var view: EditTodoViewController?
    weak var mainRouterDelegate: MainRouterProtocol?
    let router: EditTodoRouterProtocol
    let interactor: EditTodoInteractorProtocol
    
    init(interactor: EditTodoInteractorProtocol, router: EditTodoRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension EditTodoPresenter: EditTodoPresenterProtocol {
    func dissmisVC(_ editItem: ToDoItem) {
        mainRouterDelegate?.closeEditModule(editItem)
        router.dissmis()
    }
    
    func updateTodo(label: String?, text: String) {
        interactor.updateDataInCoreData(label: label, text: text)
    }
    
    func showDataInScreen(date: Date, label: String, text: String) {
        view?.configureScreen(date: date, label: label, text: text)
    }
    
    func viewDidLoaded() {
        interactor.getData()
    }
    
}
