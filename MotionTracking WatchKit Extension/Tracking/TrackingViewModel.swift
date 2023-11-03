//
//  TrackingViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import WatchKit
import Combine

class TrackingViewModel: BaseViewModel, ManagerInjector {
    
    /// Propertie
    var motionManager: MotionManager?
    var timer: Timer?
    
    /// Input observable
    @Published var appearScreen = false
    
    /// Output observable
    @Published var isStartTraking = true
    @Published var timerValue = Parameters.getTimer() + 0.5
    var isFileSaved = PassthroughSubject<(), ErrorApp>()
    var isShowSaveDataMessage = PassthroughSubject<(), Never>()
    var isStopTracking = PassthroughSubject<(), Never>()
    
    
    // MARK: Override method
    
    override func context(object: Any?) {
        motionManager = object as? MotionManager
    }
    
    override func observers() {
        super.observers()
        
        Publishers.CombineLatest($isStartTraking, $appearScreen)
            .eraseToAnyPublisher()
            .filter { !$0 && $1 }
            .map { _ in () }
            .sink {[weak self] _ in
                self?.isShowSaveDataMessage.send(())
            }
            .store(in: &cancellable)
        
    }
    
    // MARK: Public method
    
    func stopTracking() {
        motionManager?.stopUpdates()
        isStartTraking = false
        timer?.invalidate()
        isStopTracking.send(())
    }
    
    func startTraking() {
        motionManager?.startUpdates()
        isStartTraking = true
        startTimer()
    }
    
    func saveData() {
        
        guard let result = motionManager?.resultMotion else { return }
        do {
            // Write json file
            let json = try JSONEncoder().encode(entity: result)
            let filePath = try fileTrackingManager.writeFileTransfer(
                json: json,
                location: Parameters.getLocation(),
                time: Parameters.getTimer(),
                count: result.count
            )
            
            // Transfer json file to iPhone
            connectivityManager.sendFile(file: filePath)
            isFileSaved.send(())
            isFileSaved.send(completion: .finished)
        } catch {
            isFileSaved.send(completion: .failure(
                ErrorApp(
                    title: "File erreur",
                    description: "The message could not be saved: \(error.localizedDescription)"
                )
            ))
        }
    }
    
    // MARK: Private method
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerValue, repeats: false) { [weak self] _ in
            self?.stopTracking()
        }
    }
    
}


extension JSONEncoder {
    
    func encode<T>(entity: T) throws -> String where T : Encodable {
        let jsonData = try self.encode(entity)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            return json
        }
        throw NSError(
            domain: "com.kangama.MotionTracking",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Json error"]
        )
    }
    
}
