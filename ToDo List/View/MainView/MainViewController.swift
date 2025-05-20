//
//  MainViewController.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    
}

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
    }
    
}

extension MainViewController: MainViewProtocol {
    
}
