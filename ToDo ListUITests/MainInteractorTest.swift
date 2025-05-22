//
//  MainInteractorTest.swift
//  ToDo ListUITests
//
//  Created by KazbekMusaev on 22.05.2025.
//

import XCTest
@testable import ToDo_List

final class MainInteractorTest: XCTestCase {

    var interactor: MainInteractor!
    var presenter: MockPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MainInteractor()
        presenter = MockPresenter(interator: interactor)
        interactor.presenter = presenter
    }
    
    override func tearDown() {
        interactor = nil
        presenter = nil
        super.tearDown()
    }
    
    //MARK: - Тест первого обращения к Api
    ///Тут она сохраняет объекты в кор дату, при вызове этого теста. Здесь я в чем-то ошибся
    func test_fetchData_loadsFromNetworkIfFirstLaunch() {
        UserDefaults.standard.set(false, forKey: "isLoadFirstData")
        
        let expectation = self.expectation(description: "First Launch Loads Data")
        
        interactor.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.presenter.didLoadTasksCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    //MARK: - Тест обновления данных
    func test_getUpdateData_callsPresenterWithUpdatedModel() {
        interactor.getUpdateData()
        
        let expectation = self.expectation(description: "Update Data")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.presenter.updateCollectionModel)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    //MARK: - Тест поиска
    func test_searchToDos_emptyQuery_returnsAll() {
        interactor.searchToDos("")
        
        let expectation = self.expectation(description: "Search ToDos")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.presenter.searchResult)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    //MARK: - Тест обновление элемента
    func test_updateItem_shouldCallReloadItem() {
        let item = ToDoItem(id: 123, todo: "Test", completed: false, userId: 123, date: Date(), label: nil)
        
        CoreManager.shared.createData(item: item)
        
        interactor.updateItem(item)
        
        let expectation = self.expectation(description: "Update Item")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.presenter.reloadItemCalled)
            XCTAssertEqual(self.presenter.reloadedItem?.id, item.id)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    //MARK: - Тест удаления элемента из коллекции
    func test_deleteItem_shouldCallItemIsDeleted() {
        let item = ToDoItem(id: 123, todo: "Test", completed: false, userId: 123, date: Date(), label: "Test")
        
        CoreManager.shared.createData(item: item)
        
        interactor.deleteItem(item)
        
        let expectation = self.expectation(description: "Delete Item")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.presenter.itemDeleted?.id, item.id)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
}


final class MockPresenter: MainPresenterProtocol {
    
    let interator: MainInteractorProtocol
    
    init(interator: MainInteractorProtocol) {
        self.interator = interator
    }
    
    var didLoadTasksCalled = false
    var didLoadTasksData: [ToDoItem]?
    
    var getErrorCalled = false
    var errorPassed: Error?
    
    var reloadItemCalled = false
    var reloadedItem: ToDoItem?
    
    var itemDeleted: ToDoItem?
    var searchResult: [ToDoItem]?
    var updateCollectionModel: [ToDoItem]?
    
    func viewDidLoaded() {}
    func didLoadTasks(_ model: [ToDoItem]) {
        didLoadTasksCalled = true
        didLoadTasksData = model
    }
    func getError(_ error: any Error) {
        getErrorCalled = true
        errorPassed = error
    }
    func presentCreateNewItemModule() {}
    func updateItem(_ item: ToDoItem) {}
    func reloadItem(_ item: ToDoItem) {
        reloadItemCalled = true
        reloadedItem = item
    }
    func startSeacrh(_ text: String) {}
    func searchIsComplete(_ model: [ToDoItem]) {
        searchResult = model
    }
    func finishCreateNewTask() {}
    func updateCollectionView(_ model: [ToDoItem]) {
        updateCollectionModel = model
    }
    func showNavController() {}
    func tapToDeleteItem(_ item: ToDoItem) {}
    func itemIsDeleted(_ item: ToDoItem) {
        itemDeleted = item
    }
    func tapToSharedBtn(_ item: ToDoItem) {}
    func tapToEditBtn(_ item: ToDoItem) {}
}

