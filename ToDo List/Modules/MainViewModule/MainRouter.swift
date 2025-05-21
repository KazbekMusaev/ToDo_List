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
    func shareTodo(_ item: ToDoItem)
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
    
    func shareTodo(_ item: ToDoItem) {
        DispatchQueue.global().async {
            let activityVC = UIActivityViewController(
                activityItems: [
                  """
                    \(item.label == nil ? "Нет заголовка" : item.label!)
                    
                    \(item.todo)
                    
                    Дата: \(item.date == nil ? "Нет даты" : item.date!.getStr())
                    """
                ],
                applicationActivities: nil
            )
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.present(activityVC, animated: true)
            }
        }
    }
}
