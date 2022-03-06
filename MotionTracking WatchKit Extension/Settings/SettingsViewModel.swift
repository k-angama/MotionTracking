//
//  SettingsViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 01/02/2022.
//

import Foundation
import Combine

class SettingsViewModel: BaseViewModel {

    /// Output observer
    @Published var herzValue = Parameters.getMotionInterval()
    @Published var timerValue = Parameters.getTimer()
    @Published var locationValue = Parameters.getLocation()
    
    /// Output propertie
    var timeRange = Constants.Configuration.timeRange
    
    /// Input observer
    var indexPickerValue = PassthroughSubject<Int, Never>()
    
    
    // MARK: Override methode
    
    override func exeUseCase() {
        super.exeUseCase()
        
        setupIndexPicker()
    }
    
    override func observers() {
        super.observers()
        
        // Set herz value to UserDefaults
        $herzValue.dropFirst()
            .sink { value in
                Parameters.setMotionInterval(value: value)
            }
            .store(in: &cancellable)
        
        // Set location value to UserDefaults
        $locationValue.dropFirst()
            .sink { value in
                Parameters.setLocation(value: value)
            }
            .store(in: &cancellable)
        
        // Set timer value to UserDefaults
        indexPickerValue.dropFirst()
            .compactMap { [weak self] index in
                self?.timeRange[index]
            }
            .sink { value in
                Parameters.setTimer(value: Double(value))
            }
            .store(in: &cancellable)

    }
    
    // MARK: Private methode
    
    private func setupIndexPicker() {
        indexPickerValue.send( timeRange.firstIndex(of: Int(Parameters.getTimer())) ?? 0 )
    }
}
