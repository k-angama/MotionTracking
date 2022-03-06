//
//  TrackingInterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 19/01/2022.
//

import WatchKit
import Foundation
import UIKit

class TrackingInterfaceController: BaseInterfaceController<TrackingViewModel> {
    
    @IBOutlet weak var interfaceTimer: WKInterfaceTimer!
    
    // MARK: Override method
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        viewModel.startTraking()
    }
    
    override func didAppear() {
        // Inform the viewmodel that the view is displayed
        // For the alert message 'Save data'
        viewModel.appearScreen = true
    }
    
    override func willDisappear() {
        // Inform the viewmodel that the view is not displayed
        viewModel.appearScreen = false
    }
    
    override func setupObservers() {
        super.setupObservers()
        
        // Start timer
        viewModel.$isStartTraking
            .receive(on: DispatchQueue.main)
            .assign(to: \.isStart, on: interfaceTimer)
            .store(in: &cancellable)
        
        // Display initial timer
        viewModel.$timerValue
            .receive(on: DispatchQueue.main)
            .map { Date(timeIntervalSinceNow: $0) }
            .assign(to: \.date, on: interfaceTimer)
            .store(in: &cancellable)
        
        // When tracking is finished, return to this screen if user is on the result screen
        viewModel.isStopTracking
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.becomeCurrentPage() // Returns to this screen.
                WKInterfaceDevice.current().play(.success)
            })
            .store(in: &cancellable)
        
        // Displays the save data alert message if the timer is over
        // and the user returns to this screen.
        viewModel.isShowSaveDataMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.showAlertSaveData()
            })
            .store(in: &cancellable)
        
        // When file saved, return on the home screen
        // Display a message, if there is an error
        viewModel.isFileSaved
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.showAlertErrorMessage(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] _ in
                self?.reloadStartScreen()
            })
            .store(in: &cancellable)

        
    }
    
    // MARK: Action method
    
    @IBAction func stopAction() {
        viewModel.stopTracking()
    }
    
    // MARK: Private method
    
    private func showAlertSaveData() {
        let noAction = WKAlertAction(title: "No", style: .cancel){ [weak self] in
            self?.reloadStartScreen()
        }
        let yesAction = WKAlertAction(title: "Yes", style: .default) { [weak self] in
            self?.viewModel.saveData()
        }
        presentAlert(
            withTitle: "Tracking stoped",
            message: "Do you want save data?",
            preferredStyle: WKAlertControllerStyle.alert,
            actions: [noAction, yesAction]
        )
    }
    
    private func showAlertErrorMessage(_ error: ErrorApp) {
        let okAction = WKAlertAction(title: "Ok", style: .cancel) { [weak self] in
            self?.reloadStartScreen()
        }
        presentAlert(
            withTitle: error.title ?? "Error",
            message: error.description ?? error.localizedDescription,
            preferredStyle: WKAlertControllerStyle.alert,
            actions: [okAction]
        )
    }
    
    private func reloadStartScreen() -> Void {
        WKInterfaceController.reloadRootPageControllers(
            withNames: ["InterfaceController", "SettingsInterfaceController"],
            contexts: [],
            orientation: .horizontal,
            pageIndex: 0
        )
    }
    
}
