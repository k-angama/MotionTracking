//
//  ReadyViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation

class ReadyViewModel: BaseViewModel {
    
    var motionManager: MotionManager?
    
    override func context(object: Any?) {
        motionManager = object as? MotionManager
        
        // Start the location for start tracking in background
        motionManager?.startLocation()
    }
    
}
