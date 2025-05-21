//
//  EditTodoBuilder.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import UIKit

final class EditTodoBuilder {
    static func build(delegate: MainRouterProtocol, item: ToDoItem) -> UIViewController {
        let viewController = EditTodoViewController()
        let interactor = EditTodoInteractor(item: item)
        let router = EditTodoRouter()
        let presenter = EditTodoPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.mainRouterDelegate = delegate
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
