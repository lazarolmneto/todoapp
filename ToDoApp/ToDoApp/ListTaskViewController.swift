//
//  ViewController.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 21.12.2020.
//

import UIKit

class ListTaskViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "ListItemCell"
        static let newItemReuseIdentifier = "ListNewItemCell"
        static let deleteTitle = "Delete"
        static let doneTitle = "Done"
        static let rowDefaultSize = CGFloat(60)
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var logic: ListTaskControllerLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        self.logic = ListTaskControllerLogic(delegate: self)
        self.tableView.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logic?.loadItems()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ListItemCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.tableView.register(ListNewItemCell.self, forCellReuseIdentifier: Constants.newItemReuseIdentifier)
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.setupTableViewHeader()
    }
    
    private func setupTableViewHeader() {
        
        let header = ListHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = true
        header.heightAnchor.constraint(equalToConstant: CGFloat(80)).isActive = true
        header.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.tableView.setAndLayoutTableHeaderView(header: header)
    }
    
    private func deleteItem(indexRow: Int) {
        self.logic?.deleteItem(for: indexRow)
    }
    
    private func doneItem(indexRow: Int) {
        self.logic?.doneItem(for: indexRow)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate
extension ListTaskViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.logic?.items.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let items = self.logic?.items else {
            return UITableViewCell()
        }
        
        if indexPath.row == items.count {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newItemReuseIdentifier, for: indexPath) as? ListNewItemCell {
            
                cell.newItemDelegate = self
                return cell
            }
            
            let cell = ListNewItemCell(style: .default, reuseIdentifier: Constants.newItemReuseIdentifier)
            cell.newItemDelegate = self
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as? ListItemCell {
        
            cell.listItem = items[indexPath.row]
            return cell
        }
        
        let cell = ListItemCell(style: .default, reuseIdentifier: Constants.reuseIdentifier)
        cell.listItem = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let items = self.logic?.items else { return }
        
        if indexPath.row == items.count {
            if let newItemCell = cell as? ListNewItemCell {
                newItemCell.teste()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let items = self.logic?.items else { return nil }
        
        if indexPath.row == items.count {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: Constants.deleteTitle) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.deleteItem(indexRow: indexPath.row)
            completionHandler(true)
        }
        
        let doneAction = UIContextualAction(style: .normal,
                                        title: Constants.doneTitle) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.doneItem(indexRow: indexPath.row)
            completionHandler(true)
        }
        
        if items[indexPath.row].isFinished {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return UISwipeActionsConfiguration(actions: [doneAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let items = self.logic?.items else { return }
        
        if items.count == indexPath.row {
            return
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        Navigator.instance.navigateToDetail(localVC: self,
                                            item: items[indexPath.row])
    }
}

//MARK: ListNewItemCellDelegate
extension ListTaskViewController: ListNewItemCellDelegate {
    
    func didTapOnReturn(text: String) {
        self.logic?.createItem(title: text)
    }
}

//MARK: ListTaskControllerLogicDelegate
extension ListTaskViewController: ListTaskControllerLogicDelegate {
    
    func didUpdateItens() {
        self.tableView.reloadData()
    }
}
