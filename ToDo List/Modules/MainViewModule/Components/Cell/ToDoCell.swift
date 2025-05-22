//
//  ToDoCell.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import UIKit

final class ToDoCell: UICollectionViewCell {
    
    var maxWidth: CGFloat = 0
    
    static let reuseId = "ToDoCell"

    //Передаю сюда item, для того, чтобы в дальнейшем создать механизм нажатия кнопки completed
    var todoItem: ToDoItem?
    
    weak var delegate: MainViewProtocol?
    
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
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        return $0
    }(UIButton(primaryAction: isCompleteAction))
    
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
    }
    
    private func activeConstraint() {
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
            divider.widthAnchor.constraint(equalToConstant: maxWidth - 40)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todoDescription.text = nil
        todoDescription.textColor = .text
        todoLabel.attributedText = NSMutableAttributedString(string: "")
        todoLabel.textColor = .text
        isCompletedBtn.setImage(nil, for: .normal)
    }
    
    func configureCell(_ item: ToDoItem) {
        todoItem = item
        todoDescription.text = item.todo
        dateLabel.text = item.date?.getStr()
        
        todoLabel.attributedText = NSMutableAttributedString(string: "")
        
        if item.completed {
            isCompletedBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            isCompletedBtn.tintColor = .completed
            todoDescription.textColor = .dateLabel
            todoLabel.textColor = .dateLabel
     
            let attributedString = NSMutableAttributedString(string: item.label ?? "Nill")
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length)
            )

            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.dateLabel,
                range: NSRange(location: 0, length: attributedString.length)
            )

            todoLabel.attributedText = attributedString
        } else {
            isCompletedBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            isCompletedBtn.tintColor = .nonCompleted
            todoLabel.attributedText = NSMutableAttributedString(string: item.label ?? "Nill")
        }
        activeConstraint()
    }
    
    //MARK: - Actions
    private lazy var isCompleteAction = UIAction { [weak self] _ in
        guard let self else { return }
        guard var todo = self.todoItem else { return }
        todo.completed.toggle()
        self.delegate?.changeItem(todo)
    }
    
}
