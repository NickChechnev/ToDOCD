//
//  ViewController.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 90
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        return bar
    }()
    
    private var itemsObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        itemsObservation = viewModel.observe(\.filteredItems) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        setupConstraints()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTap))
        navigationItem.rightBarButtonItem?.tintColor = .secondaryLabel
        navigationItem.title = "ToDo"
    }
    
    @objc private func addButtonTap() {
        let alertController = UIAlertController(title: "Test",
                                   message: "Add new item",
                                   preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField()
        alertController.textFields?.first?.placeholder = "New item"
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let field = alertController.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else { return }
            self?.viewModel.createItem(title: text)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    private func editAction(at index: Int) -> UIAlertAction {
        UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            guard let self else { return }
            let editActionAlert = UIAlertController(title: "Edit the item",
                                                    message: nil,
                                                    preferredStyle: .alert)
            editActionAlert.addTextField()
            editActionAlert.textFields?.first?.text = self.viewModel.items[index].title
            
            let confirmEdit = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                guard let self,
                      let text = editActionAlert.textFields?.first?.text,
                      !text.isEmpty else { return }
                self.viewModel.updateItem(at: index, newTitle: text)
            }
            editActionAlert.addAction(confirmEdit)
            editActionAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            
            self.present(editActionAlert, animated: true)
        }
    }
    
    private func deleteAction(at index: Int) -> UIAlertAction {
        UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            DispatchQueue.main.async {
                self?.viewModel.deleteItem(at: index)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MainTableViewCell",
            for: indexPath) as? MainTableViewCell
        else {
            return UITableViewCell()
        }
        cell.taskTitleLabel.text = viewModel.filteredItems[indexPath.row].title
        cell.createdTitleLabel.text = viewModel.filteredItems[indexPath.row].dateCreated
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertSheet = UIAlertController(title: "Choose an action",
                                           message: nil,
                                           preferredStyle: .actionSheet)
        alertSheet.addAction(editAction(at: indexPath.row))
        alertSheet.addAction(deleteAction(at: indexPath.row))
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertSheet, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

