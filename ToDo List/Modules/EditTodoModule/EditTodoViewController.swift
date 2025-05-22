//
//  EditTodoViewController.swift
//  ToDo List
//
//  Created by KazbekMusaev on 21.05.2025.
//

import UIKit

protocol EditTodoViewProtocol: AnyObject {
    func configureScreen(date: Date, label: String, text: String)
}

final class EditTodoViewController: UIViewController {
    
    var presenter: EditTodoPresenterProtocol?
    
    private lazy var textViewBottomAnchorn = textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    private func settupView() {
        view.backgroundColor = .background
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDoneButtonToKeyboard()
        settupUI()
    }
    
    private func settupUI() {
        view.addSubview(labelTextField)
        view.addSubview(dateLabel)
        view.addSubview(textView)
        view.addSubview(closeBtn)
        NSLayoutConstraint.activate([
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            
            labelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTextField.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 20),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: labelTextField.bottomAnchor, constant: 8),
            
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textViewBottomAnchorn,
        ])
    }
    
    func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)

        textView.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            textViewBottomAnchorn.constant = -keyboardHeight + view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textViewBottomAnchorn.constant = 12
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    //MARK: - View elements
    private lazy var labelTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.defaultTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 34),
            .foregroundColor: UIColor.text
        ]
       
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var dateLabel: UILabel = ComponentBuilder.getDateLabel()
    
    private lazy var textView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.textColor = .text
        $0.font = .systemFont(ofSize: 18)
    
        $0.addSubview(placeholderForTextView)
        
        NSLayoutConstraint.activate([
            placeholderForTextView.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 6),
            placeholderForTextView.topAnchor.constraint(equalTo: $0.topAnchor, constant: 8),
            placeholderForTextView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
        ])
        
        $0.delegate = self
        
        return $0
    }(UITextView())
    
    private lazy var placeholderForTextView: UILabel = ComponentBuilder.getDescriptionForTodo(.systemFont(ofSize: 18))
    
    private lazy var closeBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let art = NSAttributedString(string: "Назад", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.completed])
        $0.setAttributedTitle(art, for: .normal)
        $0.tintColor = .completed
        
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.left"))
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.tintColor = .completed
        
        $0.addSubview(chevronImage)
        
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: $0.leadingAnchor, constant: -6),
            chevronImage.centerYAnchor.constraint(equalTo: $0.centerYAnchor)
        ])
        
        return $0
    }(UIButton(primaryAction: closeAction))
    
    //MARK: - Actions
    private lazy var closeAction = UIAction { [weak self] _ in
        guard let self else { return }
        presenter?.updateTodo(label: labelTextField.text, text: textView.text ?? "")
    }
}

extension EditTodoViewController: CreateTodoViewProtocol {
    func configureScreen(date: Date, label: String, text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.settupView()
            self.dateLabel.text = date.getStr()
            self.labelTextField.text = label
            self.textView.text = text
        }
    }
}

extension EditTodoViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty else {
            placeholderForTextView.isHidden = false
            return
        }
        placeholderForTextView.isHidden = true
    }
}
