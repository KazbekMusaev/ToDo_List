//
//  MainPresenter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoadTasks(_ model: [ToDoItem])
    func getError(_ error: Error)
    func didSelectItem()
    func presentCreateNewItemModule()
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    let router: MainRouterProtocol
    let interactor: MainInteractorProtocol
    
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

extension MainPresenter: MainPresenterProtocol {
    
    func viewDidLoaded() {
        interactor.fetchData()
    }
    
    func didLoadTasks(_ model: [ToDoItem]) {
        view?.showTasks(model)
    }
    
    func getError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
    
    func didSelectItem() {
        print("select")
    }
    
    func presentCreateNewItemModule() {
        router.showCreateScreen()
    }
}
