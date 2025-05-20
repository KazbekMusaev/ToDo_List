//
//  CreateTodoBuilder.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

final class CreateTodoBuilder {
    static func build() -> UIViewController {
        let viewController = CreateTodoViewController()
//        let interactor = MainInteractor()
//        let router = MainRouter()
//        let presenter = MainPresenter(router: router, interactor: interactor)
//        
//        
//        viewController.presenter = presenter
//        presenter.view = viewController
//        interactor.presenter = presenter
//        router.presenter = presenter
        
        return viewController
    }
}


