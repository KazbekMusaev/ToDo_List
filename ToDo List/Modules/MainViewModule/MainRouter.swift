//
//  MainRouter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func showCreateScreen()
    func closeCreateModule()
}

final class MainRouter: MainRouterProtocol {
    
    weak var presenter: MainPresenterProtocol?
    weak var viewController: MainViewController?
    
    func showCreateScreen() {
        let createToDoVC = CreateTodoBuilder.build(delegate: self)
        viewController?.navigationController?.pushViewController(createToDoVC, animated: true)
    }
    
    func closeCreateModule() {
        presenter?.finishCreateNewTask()
        presenter?.showNavController()
    }
}
