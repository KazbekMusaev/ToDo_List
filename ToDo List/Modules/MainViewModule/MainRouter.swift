//
//  MainRouter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func showCreateScreen()
}

final class MainRouter: MainRouterProtocol {
    weak var presenter: MainPresenterProtocol?
    weak var viewController: MainViewController?
    
    func showCreateScreen() {
        let createToDoVC = CreateTodoBuilder.build()
        viewController?.navigationController?.pushViewController(createToDoVC, animated: true)
    }
}
