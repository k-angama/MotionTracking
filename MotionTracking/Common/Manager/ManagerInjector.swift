//
//  ManagerInjector.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import Foundation


protocol ManagerInjector {
    var fileTrackingManager: FileTrackingManager { get }
    var connectivityManager: ConnectivityManager { get }
}

fileprivate let sharedConnectivityManager = ConnectivityManager()
fileprivate let sharedFileTrackingManager = FileTrackingManager(connectivityManager: sharedConnectivityManager)
extension ManagerInjector {
    var fileTrackingManager: FileTrackingManager {
        return sharedFileTrackingManager
    }
    var connectivityManager: ConnectivityManager {
        return sharedConnectivityManager
    }
}
