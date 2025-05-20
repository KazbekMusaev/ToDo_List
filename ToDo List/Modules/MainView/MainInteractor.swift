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
        
        let isLoadFirstData = UserDefaults.standard.bool(forKey: "isLoadFirstData")
        if !isLoadFirstData {
            NetworkService.getData { result in
                switch result {
                case .success(let todoData):
                    UserDefaults.standard.set(true, forKey: "isLoadFirstData")
                    print(todoData)
                case .failure(let error):
                    print(error.localizedDescription)
                    UserDefaults.standard.set(false, forKey: "isLoadFirstData")
                }
            }
        }
    }
}
