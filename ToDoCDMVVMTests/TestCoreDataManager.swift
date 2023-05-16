//
//  TestCoreDataStack.swift
//  ToDoCDMVVMTests
//
//  Created by Никита Чечнев on 16.05.2023.
//

import CoreData
import ToDoCDMVVM

final class TestCoreDataManager: CoreDataManager {
    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "ToDoCDMVVM")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved erorr \(error), \(error.userInfo)")
            }
        }
        
        persistentContainer = container
        
    }
}
