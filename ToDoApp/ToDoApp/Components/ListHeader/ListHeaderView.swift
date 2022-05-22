//
//  ListHeaderView.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 05/05/22.
//

import UIKit

class ListHeaderView: UIView {

    private enum Constants {
        static let todayLabelFontSize = CGFloat(30)
        static let defaultFrameSize = CGFloat(80)
        static let leadingTodayLabelAnchor = CGFloat(20)
        static let titleToday = "Tasks"
    }
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = FontGenerator.defaultFont(with: Constants.todayLabelFontSize)
        label.numberOfLines = 1
        label.text = Constants.titleToday
        return label
    }()
    
    //TODO: Creat filters base on date of tasks
//    private let todoNumberLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontGenerator.defaultFont(with: Constants.defaultFontSize)
//        label.numberOfLines = 1
//        return label
//    }()
//
//    private let doneNumberLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontGenerator.defaultFont(with: Constants.defaultFontSize)
//        label.numberOfLines = 1
//        return label
//    }()

    init() {
        super.init(frame: CGRect.zero)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        
        self.addSubview(self.todayLabel)
        
        self.todayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.todayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: Constants.leadingTodayLabelAnchor).isActive = true
        self.todayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
}
