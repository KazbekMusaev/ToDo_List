//
//  MainPresenter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
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
}
