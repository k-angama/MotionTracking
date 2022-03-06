//
//  InterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 19/01/2022.
//

import WatchKit
import Foundation
import Combine


class HomeInterfaceController: BaseInterfaceController<HomeViewModel> {

    @IBOutlet weak var indicatorImage: WKInterfaceImage!
    @IBOutlet weak var numberSavedLabel: WKInterfaceLabel!
    @IBOutlet weak var numberErrorLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func setupObservers() {
        super.setupObservers()
        
        // Show the tracking screen
        viewModel.showTrackingScreen
            .sink(receiveValue: { [weak self] _ in
                self?.openReadyScreen()
            })
            .store(in: &cancellable)
        
        // Show alert message no location
        viewModel.showAlertMessageNoLocation
            .sink(receiveValue: { [weak self] _ in
                self?.showAlertMessageNoLocation()
            })
            .store(in: &cancellable)
        
        // Display loader indicator
        viewModel.$isShowLoaderIndicator
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoaderIndicator, on: indicatorImage)
            .store(in: &cancellable)
        
        // Display number files saved
        viewModel.$numberFileSending
            .receive(on: DispatchQueue.main)
            .map { "\($0)" }
            .assign(to: \.text, on: numberSavedLabel)
            .store(in: &cancellable)
        
        // Displays number files not saved
        viewModel.$numberFileError
            .receive(on: DispatchQueue.main)
            .map { "\($0)" }
            .assign(to: \.text, on: numberErrorLabel)
            .store(in: &cancellable)
            
            
    }

    @IBAction func openTrackingInterface() {
        viewModel.initMotionManager()
        viewModel.handleLocationAuthorization()
    }
    
    private func openReadyScreen() -> Void {
        guard let manager = viewModel.motionManager else { return }
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(
                    name: "ReadyInterfaceController",
                    context: manager
                )])
            }
        }
    }
    
    private func showAlertMessageNoLocation() {
        let okAction = WKAlertAction(title: "Ok, start anyway", style: .default){ [weak self] in
            self?.openReadyScreen()
        }
        presentAlert(
            withTitle: "Geolocation",
            message: "You must accept the geolocation to be able to retrieve your data in the background.",
            preferredStyle: WKAlertControllerStyle.alert,
            actions: [okAction]
        )
    }
    
}
