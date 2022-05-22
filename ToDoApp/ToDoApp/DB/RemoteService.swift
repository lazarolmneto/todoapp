//
//  RemoteService.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 16/05/22.
//

import Firebase
import FirebaseDatabase
import Foundation
import UserNotifications

enum NotificationSync: String {
    case synchronized
    
    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

struct RemoteService {

    private enum FirebaseChild: String {
        case tasks
    }
    
    let dataBaseRef: DatabaseReference
    
    private init () {
        self.dataBaseRef = Database.database().reference()
    }
    
    static let instance = RemoteService()
    
    typealias Result = (sucess:Bool, error: Error?)
    
    func addObjectListItemRealm(object: StoreObject,
                                completion: ((_ result: Result)-> Void)? = nil) {
        
        if let listItem = object as? ListItem {
            self.addTask(task: listItem, completion: completion)
        }
    }
    
    func addTask(task: ListItem,
                 completion: ((_ result: Result)-> Void)? = nil) {
        
        self.dataBaseRef.child(FirebaseChild.tasks.rawValue).child(task.uuid).setValue(task.dict) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                let result: Result = (false, error)
                completion?(result)
            } else {
                let result: Result = (true, nil)
                completion?(result)
            }
        }
    }
    
    func addTasks(tasks: [ListItem],
                  completion: ((_ result: Result)-> Void)? = nil) {
        
        for task in tasks {
            self.addTask(task: task) { result in
                if let error = result.error, !result.sucess {
                    completion?((false, error))
                } else {
                    StorageService.instance.updateRemote(item: task)
                }
            }
        }
        
        let result: Result = (true, nil)
        completion?(result)
    }
    
    func syncListItem() {
        
        self.dataBaseRef.child(FirebaseChild.tasks.rawValue).getData { error, snapshot in
            if let snapshot = snapshot,
               let value = snapshot.value as? [String: Any] {
                   var items = [ListItem]()
                   for (_, dict) in value {
                       if let dict = dict as? [String: Any] {
                           let item = ListItem(from: dict)
                           items.append(item)
                       }
                   }
                   
                   StorageService.instance.addObjects(objects: items,
                                                      shouldUpdate: true,
                                                      shouldSync: false) {
                       NotificationCenter.default.post(name: NotificationSync.synchronized.notificationName,
                                                       object: nil)
                   }
            }
        }
    }
}
