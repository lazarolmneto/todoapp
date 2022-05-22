//
//  ListItemPriority.swift
//  GetirTodo
//
//  Created by Lazaro Neto on 09/04/22.
//

import Realm
import RealmSwift

enum ListItemPriority: String, PersistableEnum {
    case medium
    case high
    case low
    
    static var allValues = [ListItemPriority.low, .medium, .high]
    
    func getColor() -> UIColor {
        
        switch self {
        case .medium: return UIColor(red: 0/255, green: 101/255, blue: 233/255, alpha: 1)
        case .high: return UIColor(red: 255/255, green: 105/255, blue: 97/255, alpha: 1)
        case .low: return UIColor(red: 11/255, green: 255/255, blue: 156/255, alpha: 1)
        }
    }
    
    func name() -> String {
        return self.rawValue.capitalized
    }
}
