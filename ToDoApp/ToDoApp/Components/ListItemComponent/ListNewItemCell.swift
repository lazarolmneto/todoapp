//
//  ListNewItemCell.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 10/04/22.
//

import UIKit

protocol ListNewItemCellDelegate {
    func didTapOnReturn(text: String)
}

class ListNewItemCell: UITableViewCell {

    private enum Constants {
        
        static let placeHolderStr = "Type new item..."
    }
    
    private let textItemView: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.placeHolderStr
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    var newItemDelegate: ListNewItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.selectionStyle = .none
        self.textItemView.translatesAutoresizingMaskIntoConstraints = false
        self.textItemView.delegate = self
        self.textItemView.text = ""
        
        self.addSubview(textItemView)
        
        self.textItemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.textItemView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.textItemView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.textItemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.textItemView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
        
        self.bringSubviewToFront(self.textItemView)
    }
    
    func teste() {
        self.bringSubviewToFront(self.textItemView)
    }
}

//MARK: UITextFieldDelegate
extension ListNewItemCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
        
            self.newItemDelegate?.didTapOnReturn(text: textField.text ?? "")
            textField.text = ""
            return false
        }
        
        return true
    }
}
