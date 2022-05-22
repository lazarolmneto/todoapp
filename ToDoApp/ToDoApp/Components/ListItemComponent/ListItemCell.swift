//
//  ListItemCell.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 09/04/22.
//

import UIKit
import SwiftUI

class ListItemCell: UITableViewCell {

    private enum Constants {
        static let defaultSizeFont = CGFloat(17)
        static let defaultCreateAtSizeFont = CGFloat(10)
        static let defaultSizePriorityView = CGFloat(12)
        static let dateFormat = "dd/MM/yyyy"
    }
    
    private let priorityView: UIView = {
        let view = UIView()
        view.backgroundColor = ListItemPriority.medium.getColor()
        return view
    }()
    
    private let textItemLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontGenerator.defaultFont(with: Constants.defaultSizeFont)
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = FontGenerator.defaultLigthFont(with: Constants.defaultCreateAtSizeFont)
        label.numberOfLines = 1
        return label
    }()
    
    var listItem: ListItem? {
        didSet {
            self.updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.priorityView.translatesAutoresizingMaskIntoConstraints = false
        self.textItemLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(priorityView)
        self.addSubview(textItemLabel)
        self.addSubview(createdAtLabel)
        
        self.priorityView.heightAnchor.constraint(equalToConstant: Constants.defaultSizePriorityView).isActive = true
        self.priorityView.widthAnchor.constraint(equalToConstant: Constants.defaultSizePriorityView).isActive = true
        self.priorityView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -Constants.defaultSizePriorityView).isActive = true
        self.priorityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.priorityView.layer.cornerRadius = Constants.defaultSizePriorityView / 2
        
        self.createdAtLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.createdAtLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.createdAtLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
        
        self.textItemLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        self.textItemLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.textItemLabel.bottomAnchor.constraint(equalTo: self.createdAtLabel.topAnchor, constant: 5).isActive = true
        self.textItemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.textItemLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
    }
    
    func updateViews() {
        
        guard let item = self.listItem else { return }
        
        self.priorityView.backgroundColor = self.listItem?.itemPriority.getColor()
        self.textItemLabel.attributedText = NSAttributedString(string: "")
        self.textItemLabel.text = item.itemText
        
        if item.isFinished {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: item.itemText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            self.textItemLabel.attributedText = attributeString
        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        var datesStr = formatter.string(from: item.createdAt)
        if let finishedAt = item.finishedAt {
            datesStr = "\(datesStr) - \(formatter.string(from: finishedAt))"
        }
        self.createdAtLabel.text = datesStr
        
    }
}
