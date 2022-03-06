//
//  ResultViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import Combine

class ResultViewModel: BaseViewModel {

    // Propertie
    weak var motionManager: MotionManager?
    
    /// Output observable
    @Published var gravityX = "-"
    @Published var gravityY = "-"
    @Published var gravityZ = "-"
    
    @Published var accelerationX = "-"
    @Published var accelerationY = "-"
    @Published var accelerationZ = "-"
    
    @Published var rotationX = "-"
    @Published var rotationY = "-"
    @Published var rotationZ = "-"
    
    
    override func context(object: Any?) {
        motionManager = object as? MotionManager
        motionManager?.delegate = self
    }
    
}

extension ResultViewModel: MotionManagerDelegate {
    
    func didUpdateMotion(_ manager: MotionManager, result: ResultMotionEnity) {
        gravityX = String(format: "%.1f", result.gravityX)
        gravityY = String(format: "%.1f", result.gravityY)
        gravityZ = String(format: "%.1f", result.gravityZ)
        
        accelerationX = String(format: "%.1f", result.userAccelerationX)
        accelerationY = String(format: "%.1f", result.userAccelerationY)
        accelerationZ = String(format: "%.1f", result.userAccelerationZ)
        
        rotationX = String(format: "%.1f", result.rotationRateX)
        rotationY = String(format: "%.1f", result.rotationRateY)
        rotationZ = String(format: "%.1f", result.rotationRateZ)
    }
    
}
