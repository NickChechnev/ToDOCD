//
//  ViewController.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        setupConstraints()
        updateView()
        setupNavigationController()
    }
    
    private func updateView() {
        viewModel.updateView = {
            DispatchQueue.main.async { [weak self] in
                self?.mainView.tableView.reloadData()
            }
        }
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
                self?.mainView.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

