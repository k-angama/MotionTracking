//
//  HomeViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import WatchKit
import Combine

class HomeViewModel: BaseViewModel, ManagerInjector {
    
    /// Propertie
    var motionManager:MotionManager?
    
    /// Output
    @Published var numberFileSending = CurrentSession.numberFileSending
    @Published var numberFileError = CurrentSession.numberFileError
    @Published var isShowLoaderIndicator = false
    var showAlertMessageNoLocation = PassthroughSubject<Void, Never>()
    var showTrackingScreen = PassthroughSubject<Void, Never>()
    
    
    // MARK: Override method
    
    override func setup() {
        super.setup()
        connectivityManager.delegate = self
        setupFiletranfertIndicator()
    }
    
    // MARK: Public method
    
    func initMotionManager() {
        motionManager = MotionManager(
            sampleInterval: Parameters.getMotionInterval(),
            addDataLocation: Parameters.getLocation()
        )
        motionManager?.delegateLocation = self
    }
    
    func handleLocationAuthorization() {
        motionManager?.authorization()
    }
    
    // MARK: Private method
        
    private func setupFiletranfertIndicator() {
        
        if connectivityManager.isFileTransfer {
            isShowLoaderIndicator = true
        }
    }
    
}

// MARK: Location Manager Delegate

extension HomeViewModel: LocationManagerDelegate {
    
    func userAuthorization(response: Bool) {
        if response {
            showTrackingScreen.send(())
        }else{
            showAlertMessageNoLocation.send(())
        }
    }

}

// MARK: Connectivity Manager Delegate

extension HomeViewModel: ConnectivityManagerDelegate {
    
    func didFinishFileTransfer(error: Error?) {
        isShowLoaderIndicator = false
        if error == nil {
            numberFileSending = CurrentSession.addNumberFileSending()
        }else{
            numberFileError =  CurrentSession.addNumberFileError()
        }
    }

}
