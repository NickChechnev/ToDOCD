//
//  ViewModel.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import Foundation

final class MainViewModel {
    
    public var updateView:(() -> ())?
    
    func numberOfRows() -> Int {
        let numberOfItems = CoreDataManager.shared.fetchItems()
        return numberOfItems.count
    }
    
    func createItem(title: String) {
        
        CoreDataManager.shared.createItem(title: title)
    }
    
    func getItemsList() -> [Item] {
        CoreDataManager.shared.fetchItems()
    }
    
    func updateItem(item: Item, newTitle: String) {
        CoreDataManager.shared.updateItem(item: item, newTitle: newTitle)
    }
    
    func deleteItem(item: Item) {
        CoreDataManager.shared.deleteItem(item: item)
    }
}
