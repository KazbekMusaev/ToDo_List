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
    func tapToCreateButton()
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
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.searchTextField.delegate = self
        
        settupUI()
    }
    
    private func settupUI() {
        view.addSubview(todoCollectioView)
        view.addSubview(bottomPanelView)
        
        NSLayoutConstraint.activate([
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomPanelView.heightAnchor.constraint(equalToConstant: 83),
            
            todoCollectioView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoCollectioView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoCollectioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoCollectioView.bottomAnchor.constraint(equalTo: bottomPanelView.topAnchor),
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
    
    private lazy var bottomPanelView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .bottomPanel
        
        $0.addSubview(allTodoCountLabel)
        $0.addSubview(createNewTaskButton)
        
        NSLayoutConstraint.activate([
            createNewTaskButton.trailingAnchor.constraint(equalTo: $0.trailingAnchor),
            createNewTaskButton.topAnchor.constraint(equalTo: $0.topAnchor),
            createNewTaskButton.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -34),
            
            allTodoCountLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 68),
            allTodoCountLabel.topAnchor.constraint(equalTo: $0.topAnchor, constant: 20),
            allTodoCountLabel.trailingAnchor.constraint(equalTo: createNewTaskButton.leadingAnchor),
            allTodoCountLabel.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -49)
        ])
        
        return $0
    }(UIView())
    
    private lazy var createNewTaskButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .completed
        $0.widthAnchor.constraint(equalToConstant: 68).isActive = true
        return $0
    }(UIButton(primaryAction: createNewTaskAction))
    
    private lazy var allTodoCountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16)
        $0.text = "0 Задач"
        $0.textColor = .text
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())
    
    //MARK: - Action
    private lazy var createNewTaskAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.tapToCreateButton()
    }
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
    func tapToCreateButton() {
        presenter?.presentCreateNewItemModule()
    }
    
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
            UIView.animate(withDuration: 0.5) {
                self?.allTodoCountLabel.text = "\(model.count) Задач"
            }
        }
    }
    
    func showError(_ errorText: String) {
//        DispatchQueue.main.async() { [weak self] in
//            print(errorText)
//        }
    }
}

//MARK: - UISearchControllerDelegate
extension MainViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    //Здесь будет реализация поиска. Сделаю при вводе каждой новой буквы, так как данные хранятся в кор дате. И у нас не идет загрузка из сети
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text)
    }
    
}
