//
//  ListItem.swift
//  GetirTodo
//
//  Created by Lazaro Neto on 09/04/22.
//

import Realm
import RealmSwift

class ListItem: Object, StoreObject {
    
    private enum Constants {
        static let dateFormat = "dd/MM/yyyy"
    }
    
    private enum Keys: String {
        case uuid
        case itemText
        case isFinished
        case createdAt
        case finishedAt
        case isDeleted
        case itemPriority
    }
    
    @Persisted(primaryKey: true) private(set) var uuid = UUID().uuidString
    @Persisted var itemText = ""
    @Persisted var isFinished = false
    @Persisted var createdAt = Date()
    @Persisted var finishedAt: Date?
    @Persisted var isDeleted = false
    @Persisted var itemPriority = ListItemPriority.low
    @Persisted var isRemote = false
    
    var dict: [String: Any] {
        var dict = [String:Any]()
        
        dict[Keys.uuid.rawValue] = self.uuid
        dict[Keys.itemText.rawValue] = self.itemText
        dict[Keys.isFinished.rawValue] = self.isFinished
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        dict[Keys.createdAt.rawValue] = formatter.string(from: self.createdAt)
        if let finishedAt = self.finishedAt {
            dict[Keys.finishedAt.rawValue] = formatter.string(from: finishedAt)
        }
        dict[Keys.isDeleted.rawValue] = self.isDeleted
        dict[Keys.itemPriority.rawValue] = self.itemPriority.rawValue
        
        return dict
    }
    
    override init() {}
    
    required init(from dict: [String : Any]) {
        super.init()
        self.uuid = dict[Keys.uuid.rawValue] as? String ?? ""
        self.itemText = dict[Keys.itemText.rawValue] as? String ?? ""
        self.isDeleted = dict[Keys.isDeleted.rawValue] as? Bool ?? false
        self.isFinished = dict[Keys.isFinished.rawValue] as? Bool ?? false
        if let priority = dict[Keys.itemPriority.rawValue] as? String {
            self.itemPriority = ListItemPriority(rawValue: priority) ?? .low
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        if let createdAt = dict[Keys.createdAt.rawValue] as? String {
            self.createdAt = formatter.date(from: createdAt) ?? Date()
        }
        
        if let finishedAt = dict[Keys.finishedAt.rawValue] as? String {
            self.finishedAt = formatter.date(from: finishedAt)
        }
    }
}
