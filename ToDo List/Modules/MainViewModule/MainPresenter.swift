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
    func presentCreateNewItemModule()
    //Также эти два метода можно будет использовать при редактировании и удалении таска
    //Метод для обновления данных в кор дата. Который пойдет в interactor
    func updateItem(_ item: ToDoItem)
    //Метод который вызовется из interactor. Для обновления секции в UICollectionView. Тут передаю модель самого ToDoItem. Чтобы потом обновить model в ViewController, через Id
    func reloadItem(_ item: ToDoItem)
    func startSeacrh(_ text: String)
    func searchIsComplete(_ model: [ToDoItem])
    func finishCreateNewTask()
    func updateCollectionView(_ model: [ToDoItem])
    func showNavController()
    func tapToDeleteItem(_ item: ToDoItem)
    func itemIsDeleted(_ item: ToDoItem)
    func tapToSharedBtn(_ item: ToDoItem)
    func tapToEditBtn(_ item: ToDoItem)
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
    func tapToEditBtn(_ item: ToDoItem) {
        router.showEditModule(item)
    }
    
    func tapToSharedBtn(_ item: ToDoItem) {
        router.shareTodo(item)
    }
    
    func itemIsDeleted(_ item: ToDoItem) {
        view?.deleteCompleted(item)
    }
    
    func tapToDeleteItem(_ item: ToDoItem) {
        interactor.deleteItem(item)
    }
    
    func showNavController() {
        view?.showNavigationController()
    }
    
    func updateCollectionView(_ model: [ToDoItem]) {
        view?.reloadCollectionView(model)
    }
    
    func finishCreateNewTask() {
        interactor.getUpdateData()
    }
    
    func startSeacrh(_ text: String) {
        interactor.searchToDos(text)
    }
    
    func searchIsComplete(_ model: [ToDoItem]) {
        view?.showSearchResult(model)
    }
    
    func reloadItem(_ item: ToDoItem) {
        view?.reloadItem(item)
    }
    
    func updateItem(_ item: ToDoItem) {
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
    
    func presentCreateNewItemModule() {
        router.showCreateScreen()
    }
}
