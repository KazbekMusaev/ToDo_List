//
//  EditTodoRouter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import Foundation

protocol EditTodoRouterProtocol: AnyObject {
    func dissmis()
}

final class EditTodoRouter: EditTodoRouterProtocol {

    weak var presenter: EditTodoPresenterProtocol?
    weak var viewController: EditTodoViewController?
    
    func dissmis() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
}
