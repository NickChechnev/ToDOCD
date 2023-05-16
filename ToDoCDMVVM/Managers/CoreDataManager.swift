//
//  CoreDataManager.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ToDoCDMVVM")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func createItem(title: String) -> Item {
        let newItem = Item(context: managedObjectContext)
        newItem.title = title
        newItem.dateCreated = Date().formatted(date: .numeric, time: .shortened)
        do {
            try managedObjectContext.save()
        } catch {
            print("Error creating new item")
        }
        return newItem
    }
    
    func fetchItems() -> [Item] {
        do {
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            let items = try managedObjectContext.fetch(fetchRequest)
            return items
        } catch {
            print("Error fetching items list")
            return []
        }
    }
    
    func deleteItem(item: Item) {
        managedObjectContext.delete(item)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error deleting item")
        }
    }
    
    func updateItem(item: Item, newTitle: String) {
        item.title = newTitle
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error updating item")
        }
    }
}

