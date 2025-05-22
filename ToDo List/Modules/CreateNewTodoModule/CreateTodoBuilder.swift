//
//  CreateTodoBuilder.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

final class CreateTodoBuilder {
    static func build(delegate: MainRouterProtocol) -> UIViewController {
        let viewController = CreateTodoViewController()
        let interactor = CreateTodoInteractor()
        let router = CreateTodoRouter()
        let presenter = CreateTodoPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.mainRouterDelegate = delegate
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}


