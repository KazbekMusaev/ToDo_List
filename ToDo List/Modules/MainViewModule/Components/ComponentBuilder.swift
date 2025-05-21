//
//  ComponentBuilder.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

final class ComponentBuilder {
    private init () {}
    
    static func getLabelForTodo(_ font: UIFont = .boldSystemFont(ofSize: 16)) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = .text
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }
    
    static func getDescriptionForTodo(
        _ font: UIFont = .systemFont(ofSize: 12),
        _ numberOfLines: Int = 2
    ) -> UILabel {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = .text
        description.font = font
        description.textAlignment = .left
        description.numberOfLines = numberOfLines
        return description
    }
    
    static func getDateLabel() -> UILabel {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .left
        dateLabel.textColor = .dateLabel
        dateLabel.font = .systemFont(ofSize: 12)
        return dateLabel
    }
    
    static func getDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.backgroundColor = .dateLabel
        return divider
    }
    
    static func makePreview(_ item: ToDoItem) -> UIViewController {
        let label = ComponentBuilder.getLabelForTodo()
        let dateLabel = ComponentBuilder.getDateLabel()
        let textLabel = ComponentBuilder.getDescriptionForTodo()
        
        let vc = UIViewController()
        vc.view.backgroundColor = .bottomPanel
        vc.view.layer.cornerRadius = 12
        
        vc.view.addSubview(label)
        vc.view.addSubview(textLabel)
        vc.view.addSubview(dateLabel)
        
        label.text = item.label
        textLabel.text = item.todo
        dateLabel.text = item.date?.getStr()
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            
            textLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            
            dateLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -12),
        ])
        
        vc.preferredContentSize = CGSize(width: 320, height: 106)
        return vc
    }
    
}
