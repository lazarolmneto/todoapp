//
//  StorageService.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 26/04/22.
//

import Realm
import RealmSwift

protocol StoreObject: Object {
    
    var isDeleted: Bool {get set}
    var isRemote: Bool {get set}
    var dict: [String: Any] {get}
    
    init(from dict: [String: Any])
}

protocol RealmObject {
    
    func realmCopy()
}

struct StorageService {
    
    fileprivate var realmInstance: Realm?
    
    static let instance = StorageService()
    
    private init() {
        let objectTypes = [ListItem.self]
        let config = Realm.Configuration.init(objectTypes: objectTypes)
        self.realmInstance = try? Realm(configuration: config)
    }
    
    func addObject(object: StoreObject,
                   shouldUpdate: Bool = false,
                   shouldSync: Bool = false,
                   callback: (()->Void)?) {
        
        self.writeTransationInRealm {
            object.isRemote = false
            if shouldUpdate {
                self.realmInstance?.add(object, update: .modified)
            } else {
                self.realmInstance?.add(object)
            }
            
        } callback: {
            
            if shouldSync {
                RemoteService.instance.addObjectListItemRealm(object: object) { result in
                    if result.sucess {
                        self.writeTransationInRealm {
                            object.isRemote = true
                        }
                    }
                    callback?()
                }
            } else {
                callback?()
            }
        }
    }
    
    func addObjects(objects: [StoreObject],
                    shouldUpdate: Bool = false,
                    shouldSync: Bool = false,
                    callback: (()->Void)?) {
        
        for object in objects {
            self.addObject(object: object,
                           shouldUpdate: shouldUpdate,
                           shouldSync: shouldSync,
                           callback: nil)
        }
        
        callback?()
    }
    
    func deleteItem(item: StoreObject, callback: (()->Void)?) {
     
        self.writeTransationInRealm {
            item.isDeleted = true
        } callback: {
            callback?()
        }
    }
    
    func getObjects<T: Object>() -> [T]? {
        if let results = self.realmInstance?.objects(T.self) {
            return Array(results)
        }
        
        return []
    }
    
    fileprivate func writeTransationInRealm(block: ()->Void, callback: (()->Void)? = nil) {
        
        if (self.realmInstance?.isInWriteTransaction ?? false) {
            try? self.realmInstance?.commitWrite()
        }
        
        try? self.realmInstance?.write({
            block()
            try? self.realmInstance?.commitWrite()
            callback?()
        })
    }
}

//MARK: StoreService - ListItem funcs
extension StorageService {
    
    func doneItem(item: ListItem, callback: (()->Void)?) {
        
        self.writeTransationInRealm {
            item.isFinished = true
            item.finishedAt = Date()
            item.isRemote = false
        } callback: {
            
            self.trySyncTasks()
            callback?()
        }
    }
    
    func changePriorityItem(item: ListItem, priority: ListItemPriority, callback: (()->Void)?) {
        
        self.writeTransationInRealm {
            item.itemPriority = priority
            item.isRemote = false
        } callback: {
            self.trySyncTasks()
            callback?()
        }
    }
    
    func updateRemote(item: ListItem) {
        
        self.writeTransationInRealm {
            item.isRemote = true
        }
    }
    
    func trySyncTasks() {
        
        if let results: [ListItem] = self.realmInstance?.objects(ListItem.self).filter( { !$0.isRemote }) {
            RemoteService.instance.addTasks(tasks: results) { result in
                NotificationCenter.default.post(name: NotificationSync.synchronized.notificationName,
                                                object: nil)
            }
        }
    }
}
