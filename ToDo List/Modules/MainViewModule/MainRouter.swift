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
    func closeEditModule(_ editItem: ToDoItem)
    func showEditModule(_ item: ToDoItem)
}

final class MainRouter: MainRouterProtocol {
    
    weak var presenter: MainPresenterProtocol?
    weak var viewController: MainViewController?
    
    func showCreateScreen() {
        let createToDoVC = CreateTodoBuilder.build(delegate: self)
        viewController?.navigationController?.pushViewController(createToDoVC, animated: true)
    }
    
    func showEditModule(_ item: ToDoItem) {
        let editToDoVC = EditTodoBuilder.build(delegate: self, item: item)
        viewController?.navigationController?.pushViewController(editToDoVC, animated: true)
    }
    
    func closeCreateModule() {
        presenter?.finishCreateNewTask()
        presenter?.showNavController()
    }
    
    func closeEditModule(_ editItem: ToDoItem) {
        presenter?.reloadItem(editItem)
        presenter?.showNavController()
    }
    
    //Здесь вызов UIActivityViewController, происходит в global потоке, я специально добавил задержку в 1 секунду, чтобы не было системных ошибок и зависаний. Не могу понять почему именно с этим UIActivityController вечно выходят баги)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.viewController?.present(activityVC, animated: true)
            }
        }
    }
}
