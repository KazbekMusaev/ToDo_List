//
//  MainViewController.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func showTasks(_ model: [ToDoItem])
    func showError(_ errorText: String)
    func changeItem(_ item: ToDoItem)
    func reloadItem(_ item: ToDoItem)
}

final class MainViewController: UIViewController {
    var model: [ToDoItem] = []
    var presenter: MainPresenterProtocol?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settupView()
        presenter?.viewDidLoaded()
    }
    
    //MARK: - Functions
    private func settupView() {
        view.backgroundColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
        settupUI()
    }
    
    private func settupUI() {
        view.addSubview(todoCollectioView)
        
        NSLayoutConstraint.activate([
            todoCollectioView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoCollectioView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoCollectioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoCollectioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    
    //MARK: - View elements
    private lazy var todoCollectioView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(ToDoCell.self, forCellWithReuseIdentifier: ToDoCell.reuseId)
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    
    private lazy var layout: UICollectionViewFlowLayout = {
        $0.itemSize = CGSize(width: view.frame.width, height: 90)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        return $0
    }(UICollectionViewFlowLayout())
    
    
    
}


//MARK: - UICollectionViewExt
extension MainViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        presenter?.presentCreateNewItemModule()
//    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCell.reuseId, for: indexPath) as? ToDoCell else {
            return UICollectionViewCell()
        }
        let item = model[indexPath.row]
        cell.configureCell(item)
        cell.delegate = self
        return cell
    }
    
    
}


//MARK: - MainViewProtocolExt
extension MainViewController: MainViewProtocol {
    func reloadItem(_ item: ToDoItem) {
        print("reloadItem -> MainViewController")
        guard let index = model.firstIndex(where: { $0.id == item.id }) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.model[index] = item
            self.todoCollectioView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        
    }
    
    func changeItem(_ item: ToDoItem) {
        print("changeItem -> MainViewController")
        presenter?.updateItem(item)
    }
    
    func showTasks(_ model: [ToDoItem]) {
        DispatchQueue.main.async() { [weak self] in
            self?.model = model
            self?.todoCollectioView.reloadData()
        }
    }
    
    func showError(_ errorText: String) {
//        DispatchQueue.main.async() { [weak self] in
//            print(errorText)
//        }
    }
}
