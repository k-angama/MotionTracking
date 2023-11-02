//
//  ManagerInjector.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import Foundation


protocol ManagerInjector {
    var fileTrackingManager: FileTrackingManager { get }
}

fileprivate let sharedFileTrackingManager = FileTrackingManager()
extension ManagerInjector {
    var fileTrackingManager: FileTrackingManager {
        return sharedFileTrackingManager
    }
}
