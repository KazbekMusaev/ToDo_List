//
//  ToDoCell.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

final class ToDoCell: UICollectionViewCell {
    
    static let reuseId = "ToDoCell"
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        settupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View elements
    private lazy var isCompletedBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.backgroundColor = .red
        return $0
    }(UIButton())
    
    private lazy var todoLabel: UILabel = ComponentBuilder.getLabelForTodo()
    private lazy var todoDescription: UILabel = ComponentBuilder.getDescriptionForTodo()
    private lazy var dateLabel: UILabel = ComponentBuilder.getDateLabel()
    private lazy var divider: UIView = ComponentBuilder.getDivider()
    
    //MARK: - Functions
    private func settupCell() {
        backgroundColor = .clear
        
        addSubview(isCompletedBtn)
        addSubview(todoLabel)
        addSubview(todoDescription)
        addSubview(dateLabel)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            isCompletedBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            isCompletedBtn.topAnchor.constraint(equalTo: topAnchor),
            
            todoLabel.leadingAnchor.constraint(equalTo: isCompletedBtn.trailingAnchor, constant: 8),
            todoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            todoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            todoDescription.leadingAnchor.constraint(equalTo: isCompletedBtn.trailingAnchor, constant: 8),
            todoDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            todoDescription.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 8),
            
            dateLabel.leadingAnchor.constraint(equalTo: isCompletedBtn.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: todoDescription.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
            
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configureCell(_ item: ToDoItem) {
        todoLabel.text = item.label
        todoDescription.text = item.todo
        dateLabel.text = item.date?.getStr()
    }
}
