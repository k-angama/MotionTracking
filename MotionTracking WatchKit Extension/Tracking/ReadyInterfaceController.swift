//
//  InterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation
import WatchKit

class ReadyInterfaceController: BaseInterfaceController<ReadyViewModel> {
    
    @IBOutlet weak var readyLabel: WKInterfaceLabel!
    @IBOutlet weak var goLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupAninimation()
    }
    
    private func setupAninimation() {
        readyLabel.setAlpha(0)
        goLabel.setAlpha(0)
        self.animation()
    }
    
    private func animation() {
        
        let duration = 0.3
        animate(withDuration: duration) { [weak self] in
            self?.readyLabel.setVerticalAlignment(.center)
            self?.readyLabel.setAlpha(1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.animate(withDuration: duration) { [weak self] in
                self?.readyLabel.setVerticalAlignment(.bottom)
                self?.readyLabel.setAlpha(0)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.animate(withDuration: duration) { [weak self] in
                self?.goLabel.setVerticalAlignment(.center)
                self?.goLabel.setAlpha(1)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.animate(withDuration: duration) { [weak self] in
                self?.goLabel.setVerticalAlignment(.bottom)
                self?.goLabel.setAlpha(0)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.openTrackingScreen()
        }
    }
    
    private func openTrackingScreen() {
        guard let manager = viewModel.motionManager else { return }
        DispatchQueue.main.async {
            WKInterfaceController.reloadRootPageControllers(
                withNames: ["ResultInterfaceController", "TrackingInterfaceController"],
                contexts: [manager, manager],
                orientation: .horizontal,
                pageIndex: 1
            )
        }
        WKInterfaceDevice.current().play(.start)
    }

}
