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
    //Также эти два метода можно будет использовать при редактировании и удалении таска
    //Метод для обновления данных в кор дата. Который пойдет в interactor
    func updateItem(_ item: ToDoItem)
    //Метод который вызовется из interactor. Для обновления секции в UICollectionView. Тут передаю модель самого ToDoItem. Чтобы потом обновить model в ViewController, через Id
    func reloadItem(_ item: ToDoItem)
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
    func reloadItem(_ item: ToDoItem) {
        print("reloadItem -> MainPresenter")
        view?.reloadItem(item)
    }
    
    func updateItem(_ item: ToDoItem) {
        print("updateItem -> MainPresenter")
        interactor.updateItem(item)
    }
    
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
