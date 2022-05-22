//
//  ListItemDetailViewLogic.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 27/04/22.
//

import UIKit

class ListItemDetailViewLogic: NSObject {

    let item: ListItem
    
    init(item: ListItem) {
        self.item = item
        super.init()
    }
    
    func updatePriority(priority: ListItemPriority) {
        
        StorageService.instance.changePriorityItem(item: self.item,
                                                   priority: priority,
                                                   callback: nil)
    }
}
