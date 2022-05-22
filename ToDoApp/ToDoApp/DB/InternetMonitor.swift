//
//  InternetMonitor.swift
//  ToDoApp
//
//  Created by Lazaro Neto on 17/05/22.
//

import Network

struct InternetMonitor {
    
    private enum Constants {
        static let queueTitle = "InternetConnectionMonitor"
    }

    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: Constants.queueTitle)
    
    static let instance = InternetMonitor()
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
            } else {
                print("There's no internet connection.")
            }
        }

        monitor.start(queue: queue)
    }
    
}
