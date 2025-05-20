//
//  MainInteractor.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

protocol MainInteractorProtocol {
    func fetchData()
}

final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?
    
    func fetchData() {
        print("start load info")
    }
}
