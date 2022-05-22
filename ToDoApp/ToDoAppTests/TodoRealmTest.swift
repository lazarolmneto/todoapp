//
//  TodoRealmTest.swift
//  ToDoAppTests
//
//  Created by Lazaro Neto on 22/05/22.
//

import XCTest
@testable import ToDoApp

class TodoRealmTest: XCTestCase {

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
        
        StorageService.instance.addObject(object: listItem, callback: nil)
        
        if let resutls: [ListItem] = StorageService.instance.getObjects() {
            let exist = resutls.contains { listItemResult in
                return listItemResult.uuid == listItem.uuid
            }
            
            return assert(exist, "Not inserted")
        }
        
        assertionFailure("could not get results")
    }
    
    func testInsertDeletedListItem() throws {
        
        let listItem = ListItem()
        listItem.isRemote = false
        listItem.createdAt = Date()
        listItem.isFinished = false
        listItem.isDeleted = true
        listItem.itemText = "Teste"
        
        StorageService.instance.addObject(object: listItem, callback: nil)
        
        if let resutls: [ListItem] = StorageService.instance.getObjects() {
            let exist = resutls.contains { listItemResult in
                return listItemResult.uuid == listItem.uuid
                        && listItemResult.isDeleted
            }
            
            return assert(exist, "Not inserted")
        }
        
        assertionFailure("could not get results")
    }
    
    func testInsertFinishedListItem() throws {
        
        let listItem = ListItem()
        listItem.isRemote = false
        listItem.createdAt = Date()
        listItem.isFinished = true
        listItem.finishedAt = Date()
        listItem.isDeleted = true
        listItem.itemText = "Teste"
        
        StorageService.instance.addObject(object: listItem, callback: nil)
        
        if let resutls: [ListItem] = StorageService.instance.getObjects() {
            let exist = resutls.contains { listItemResult in
                return listItemResult.uuid == listItem.uuid
                        && listItemResult.isFinished
            }
            
            return assert(exist, "Not inserted")
        }
        
        assertionFailure("could not get results")
    }
}
