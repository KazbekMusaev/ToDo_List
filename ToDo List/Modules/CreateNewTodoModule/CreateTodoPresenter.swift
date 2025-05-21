//
//  CreateTodoPresenter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol CreateTodoPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func showDataInScreen(date: Date, label: String, text: String)
    func createNewTodo(label: String?, text: String)
    func dissmisVC()
}

final class CreateTodoPresenter {
    weak var view: CreateTodoViewController?
    weak var mainRouterDelegate: MainRouterProtocol?
    let router: CreateTodoRouterProtocol
    let interactor: CreateTodoInteractorProtocol
    
    init(interactor: CreateTodoInteractorProtocol, router: CreateTodoRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CreateTodoPresenter: CreateTodoPresenterProtocol {
    func dissmisVC() {
        mainRouterDelegate?.closeCreateModule()
        router.dissmis()
    }
    
    func createNewTodo(label: String?, text: String) {
        interactor.saveTodoInCoreData(label: label, text: text)
    }
    
    func showDataInScreen(date: Date, label: String, text: String) {
        view?.configureScreen(date: date, label: label, text: text)
    }
    
    func viewDidLoaded() {
        interactor.getData()
    }
    
}
