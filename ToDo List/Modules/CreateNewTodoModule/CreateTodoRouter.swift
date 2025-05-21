//
//  CreateTodoRouter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol CreateTodoRouterProtocol: AnyObject {
    func dissmis()
}

final class CreateTodoRouter: CreateTodoRouterProtocol {

    weak var presenter: CreateTodoPresenterProtocol?
    weak var viewController: CreateTodoViewController?
    
    func dissmis() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
