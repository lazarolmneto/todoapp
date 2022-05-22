//
//  ViewControllerLogic.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 13/04/22.
//

import UIKit

protocol ListTaskControllerLogicDelegate: AnyObject {
    func didUpdateItens()
}

class ListTaskControllerLogic: NSObject {
    
    private(set) var items: [ListItem] = [] {
        didSet {
            self.delegate?.didUpdateItens()
        }
    }
    
    weak var delegate: ListTaskControllerLogicDelegate?
    
    init(delegate: ListTaskControllerLogicDelegate) {
        super.init()
        self.delegate = delegate
        self.addNotificationTarget()
    }
    
    func loadItems() {
        
        self.items = getItems()
    }
    
    func createItem(item: ListItem) {

        StorageService.instance.addObject(object: item,
                                          shouldUpdate: false,
                                          shouldSync: true) { [weak self] in
            guard let self = self else { return }
            self.loadItems()
        }
    }
    
    func updateItem(item: ListItem) {

        StorageService.instance.addObject(object: item,
                                          shouldUpdate: true,
                                          shouldSync: true) { [weak self] in
            guard let self = self else { return }
            self.loadItems()
        }
    }
    
    func getCountItems() -> Int {
        
        return self.items.count
    }
    
    func getItem(from index: Int) -> ListItem {
        
        return items[index]
    }
    
    func deleteItem(for index: Int) {
        
        StorageService.instance.deleteItem(item: self.items[index]) { [weak self] in
            guard let self = self else { return }
            self.loadItems()
        }
    }
    
    func doneItem(for index: Int) {
        
        StorageService.instance.doneItem(item: self.items[index]) { [weak self] in
            guard let self = self else { return }
            self.loadItems()
        }
    }
    
    func createItem(title: String) {
     
        let item = ListItem()
        item.itemText = title
        item.itemPriority = .low
        self.createItem(item: item)
        self.loadItems()
    }
    
    fileprivate func getItems() -> [ListItem] {

        if let results: [ListItem] = StorageService.instance.getObjects()?.filter( { !$0.isDeleted }) {
            return results.sorted { !$0.isFinished && $1.isFinished }
        }
        return []
    }
    
    fileprivate func addNotificationTarget() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSynchronized),
                                               name: NotificationSync.synchronized.notificationName,
                                               object: nil)
    }
    
    @objc fileprivate func didSynchronized() {
        self.loadItems()
        self.delegate?.didUpdateItens()
    }
}
