//
//  MainRouter.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    
}

final class MainRouter: MainRouterProtocol {
    weak var presenter: MainPresenterProtocol?
    
//    weak var viewController: UIViewController?
//    
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//    }
//    
//    // Пример метода
//    func showDetailsScreen() {
////        let detailVC = DetailRouter.build()
////        viewController?.navigationController?.pushViewController(detailVC, animated: true)
//    }
}
