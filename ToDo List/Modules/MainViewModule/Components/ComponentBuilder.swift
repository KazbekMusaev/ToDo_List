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
}
