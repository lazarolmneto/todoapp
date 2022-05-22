//
//  TodoFirebaseTest.swift
//  ToDoAppTests
//
//  Created by Lazaro Neto on 22/05/22.
//

import XCTest
@testable import ToDoApp

class TodoFireaseTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertListItem() throws {
        
        let listItem = ListItem()
        listItem.isRemote = false
        listItem.createdAt = Date()
        listItem.isFinished = false
        listItem.isDeleted = true
        listItem.itemText = "Teste"
        
        let expectation = XCTestExpectation(description: "test testInsertListItem")
        
        RemoteService.instance.addTask(task: listItem) { result in
            if let error = result.error {
                assertionFailure(error.localizedDescription)
            } else {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
