//
//  ViewModel.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import Foundation

final class MainViewModel: NSObject {
    
    @objc dynamic var filteredItems: [Item] = []
    @objc dynamic var items: [Item] = [] {
        didSet {
            filteredItems = items
            if let searchText {
                search(searchText)
            }
        }
    }
    
    var searchText: String? {
        didSet {
            guard let searchText else { return }
            search(searchText)
        }
    }
    
    override init() {
        super.init()
        items = CoreDataManager.shared.fetchItems()
        filteredItems = items
    }
    
    func createItem(title: String) {
        items.append(CoreDataManager.shared.createItem(title: title))
    }
    
    func updateItem(at index: Int, newTitle: String) {
        let item = items[index]
        item.title = newTitle
        items[index] = item
        CoreDataManager.shared.updateItem(item: item, newTitle: newTitle)
    }
    
    func deleteItem(at index: Int) {
        let item = items[index]
        CoreDataManager.shared.deleteItem(item: item)
        items.remove(at: index)
    }
    
    private func search(_ text: String) {
        guard !text.isEmpty else {
            filteredItems = items
            return
        }
        filteredItems = items.filter { $0.title?.contains(text) == true }
        
    }
}
