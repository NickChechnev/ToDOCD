//
//  View.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import UIKit

class MainView: UIView {
    
    var viewModel: MainViewModel = MainViewModel()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemsList = viewModel.getItemsList()
        let item = itemsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellIdentifier, for: indexPath) as! MainTableViewCell
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemList = viewModel.getItemsList()
        let item = itemList[indexPath.row]
        let alertSheet = UIAlertController(title: "Choose an action",
                                           message: nil,
                                           preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _  in
            let editActionAlert = UIAlertController(title: "Edit the item",
                                                    message: nil,
                                                    preferredStyle: .alert)
            editActionAlert.addTextField()
            editActionAlert.textFields?.first?.text = item.title
            
            let confirmEdit = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                guard let field = editActionAlert.textFields?.first,
                      let text = field.text,
                      !text.isEmpty else { return }
                self?.viewModel.updateItem(item: item, newTitle: text)
                self?.tableView.reloadData()
            }
            let cancelEdit = UIAlertAction(title: "Cancel", style: .destructive)
            
            editActionAlert.addAction(confirmEdit)
            editActionAlert.addAction(cancelEdit)
            
            editActionAlert.show(animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteItem(item: item)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertSheet.addAction(editAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(cancelAction)
        alertSheet.show(animated: true)
    }
}
