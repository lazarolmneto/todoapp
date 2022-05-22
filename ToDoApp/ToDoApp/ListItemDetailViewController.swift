//
//  ListItemDetailViewController.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 11/04/22.
//

import UIKit

class ListItemDetailViewController: UIViewController {
    
    private enum Constants {
        static let datesTitle = "Created at / Finished at"
        static let textTitle = "Task"
        static let todoTextViewPlaceHolder = "Type here"
        static let todoTextViewTextSize = "200"
        static let dateFormat = "dd/MM/yyyy"
        static let spacer50 = CGFloat(120)
        static let spacer30 = CGFloat(30)
        static let spacer20 = CGFloat(20)
        static let spacer5 = CGFloat(5)
        static let sizeFont18 = CGFloat(18)
        static let sizeFont14 = CGFloat(14)
        static let sizeFont12 = CGFloat(12)
        static let cornerRadius = CGFloat(10)
        static let heightStack = CGFloat(40)
    }
    
    private let stackViewPriority: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let lowPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle(ListItemPriority.low.name(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ListItemPriority.low.getColor()
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    private let mediumPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle(ListItemPriority.medium.name(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ListItemPriority.medium.getColor()
        button.layer.cornerRadius = Constants.cornerRadius
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let highPriorityButton: UIButton = {
        let button = UIButton()
        button.setTitle(ListItemPriority.high.name(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ListItemPriority.high.getColor()
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    private let datesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.datesTitle
        label.font = FontGenerator.defaultLigthFont(with: Constants.sizeFont18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datesDescLabel: UILabel = {
        let label = UILabel()
        label.font = FontGenerator.defaultFont(with: Constants.sizeFont18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.textTitle
        label.font = FontGenerator.defaultLigthFont(with: Constants.sizeFont18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taskTextLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.textTitle
        label.font = FontGenerator.defaultFont(with: Constants.sizeFont18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var logic: ListItemDetailViewLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        self.setupViews()
        self.addActionsToButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    private func setupViews() {
        
        self.view.isUserInteractionEnabled = true
//        self.view.addSubview(self.stackViewPriority)
//        self.view.addSubview(self.datesTitleLabel)
//        self.view.addSubview(self.datesDescLabel)
//        self.view.addSubview(self.titleTextLabel)
//        self.view.addSubview(self.todoTextView)
        
        self.view.addSubview(self.titleTextLabel)
        self.view.addSubview(self.taskTextLabel)
        self.titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.spacer30).isActive = true
        self.titleTextLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constants.spacer30).isActive = true
        
        self.taskTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.taskTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.spacer30).isActive = true
        self.taskTextLabel.topAnchor.constraint(equalTo: self.titleTextLabel.bottomAnchor, constant: Constants.spacer5).isActive = true
        
        self.view.addSubview(self.datesTitleLabel)
        self.view.addSubview(self.datesDescLabel)
        self.datesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.datesTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.spacer30).isActive = true
        self.datesTitleLabel.topAnchor.constraint(equalTo: self.taskTextLabel.bottomAnchor, constant: Constants.spacer20).isActive = true
        
        self.datesDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.datesDescLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.spacer30).isActive = true
        self.datesDescLabel.topAnchor.constraint(equalTo: self.datesTitleLabel.bottomAnchor, constant: Constants.spacer5).isActive = true
        
        self.view.addSubview(self.stackViewPriority)
        self.stackViewPriority.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewPriority.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.spacer30).isActive = true
        self.stackViewPriority.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.spacer30).isActive = true
        self.stackViewPriority.topAnchor.constraint(equalTo: self.datesDescLabel.bottomAnchor, constant: Constants.spacer20).isActive = true
        
        self.stackViewPriority.addArrangedSubview(self.lowPriorityButton)
        self.stackViewPriority.addArrangedSubview(self.mediumPriorityButton)
        self.stackViewPriority.addArrangedSubview(self.highPriorityButton)
        
    }
    
    private func updateViews() {
        
        guard let item = self.logic?.item else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        var datesStr = "\(formatter.string(from: item.createdAt)) / - "
        if let finishedAt = item.finishedAt {
            datesStr = "\(datesStr) / \(formatter.string(from: finishedAt))"
        }
        self.datesDescLabel.text = datesStr
        
        self.updateButtons(basedOn: item.itemPriority)
        
        self.taskTextLabel.text = item.itemText
    }
    
    private func updateButtons(basedOn priority: ListItemPriority) {
        
        self.updateDefaultStyleButton(button: self.lowPriorityButton, priority: .low)
        self.updateDefaultStyleButton(button: self.mediumPriorityButton, priority: .medium)
        self.updateDefaultStyleButton(button: self.highPriorityButton, priority: .high)
        
        switch priority {
        case .low:
            self.updateSelectedStyleButton(button: self.lowPriorityButton, priority: .low)
        case .medium:
            self.updateSelectedStyleButton(button: self.mediumPriorityButton, priority: .medium)
        case .high:
            self.updateSelectedStyleButton(button: self.highPriorityButton, priority: .high)
        }
    }
    
    private func updateDefaultStyleButton(button: UIButton, priority: ListItemPriority) {
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = priority.getColor().withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.2) {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
    }
    
    private func updateSelectedStyleButton(button: UIButton, priority: ListItemPriority) {
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = priority.getColor()
        UIView.animate(withDuration: 0.2) {
            button.transform = CGAffineTransform.identity
        }
    }
    
    private func addActionsToButtons() {
        
        self.lowPriorityButton.addAction(UIAction(handler: { [weak self] action in

            guard let self = self else { return }
            self.updateItemList(for: .low)
        }), for: .touchUpInside)
        
        self.mediumPriorityButton.addAction(UIAction(handler: { [weak self] action in

            guard let self = self else { return }
            self.updateItemList(for: .medium)
        }), for: .touchUpInside)
        
        self.highPriorityButton.addAction(UIAction(handler: { [weak self] action in

            guard let self = self else { return }
            self.updateItemList(for: .high)
        }), for: .touchUpInside)
    }
    
    private func updateItemList(for priority: ListItemPriority) {
        
        guard let item = self.logic?.item else { return }
        StorageService.instance.changePriorityItem(item: item,
                                                   priority: priority) { [weak self] in
            guard let self = self else { return }
            self.updateButtons(basedOn: priority)
        }
    }
}

//MARK: UITextViewDelegate
extension ListItemDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.todoTextViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
