//
//  MainTableViewCell.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 09.05.2023.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var createdTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(taskTitleLabel)
        addSubview(createdTitleLabel)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            taskTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            taskTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            taskTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            createdTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            createdTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            createdTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 255),
            createdTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
