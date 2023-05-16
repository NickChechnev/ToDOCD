//
//  TestManagerFunctionality.swift
//  ToDoCDMVVMTests
//
//  Created by Никита Чечнев on 16.05.2023.
//

import XCTest
@testable import ToDoCDMVVM
import CoreData

final class TestManagerFunctionality: XCTestCase {
    var coreDataManager: TestCoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = TestCoreDataManager()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
    }
    
    func testCreatingItem() {
        let item = coreDataManager.createItem(title: "Test")
        
        XCTAssertNotNil(item, "Item should not be nil")
        XCTAssert(item.title == "Test")
        XCTAssertNotNil(item.dateCreated, "Date should not be nil")
    }
    
    func testUpdatingItem() {
        let item = coreDataManager.createItem(title: "Test")
        let updatedItem = item
        coreDataManager.updateItem(item: updatedItem, newTitle: "Test2")
        
        XCTAssertNotNil(updatedItem, "Item should not be nil")
        XCTAssert(updatedItem.title == "Test2")
        XCTAssert(item.dateCreated == updatedItem.dateCreated)
        XCTAssertNotNil(item.dateCreated, "Date should not be nil")
    }
    
    func testFetchingItems() {
        let itemsArray = coreDataManager.fetchItems()
        
        XCTAssertNotNil(itemsArray, "Array should not be nil")
        XCTAssert(itemsArray == [Item]())
    }
    
    func testDeletingItem() {
        let itemToDelete = coreDataManager.createItem(title: "item")
        
        var itemsArray = [Item]()
        itemsArray = coreDataManager.fetchItems()
        
        XCTAssertTrue(itemsArray.count == 1)
    
        coreDataManager.deleteItem(item: itemToDelete)
        
        itemsArray = coreDataManager.fetchItems()
        
        XCTAssertTrue(itemsArray.isEmpty)
    }

}
