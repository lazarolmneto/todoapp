//
//  Navigator.swift
//  GetirTodo
//
//  Created by Lazaro Neto on 27/04/22.
//

import UIKit

enum NavigationType {
    case present
    case push
}

struct Navigator {

    static var instance = Navigator()
    
    private init() { }
    
    func navigateToDetail(localVC: UIViewController,
                          item: ListItem,
                          navigationType: NavigationType = .present) {
        let detailVC = ListItemDetailViewController()
        let logic = ListItemDetailViewLogic(item: item)
        detailVC.logic = logic
        
        switch navigationType {
        case .present:
            localVC.present(detailVC,
                            animated: true,
                            completion: nil)
        case .push:
            localVC.navigationController?.pushViewController(detailVC,
                                                             animated: true)
        }
        
    }
}
