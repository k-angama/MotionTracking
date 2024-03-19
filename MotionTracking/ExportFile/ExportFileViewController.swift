//
//  ExportFileViewController.swift
//  MotionTracking
//
//  Created by Karim Angama on 05/02/2022.
//

import Foundation
import Combine
import UIKit

class ExportFileViewController: BaseTableViewController<ExportFileViewModel> {
    
    @IBOutlet weak var titleTableViewCell: UITableViewCell!
    @IBOutlet weak var exportButton: UIBarButtonItem!
    @IBOutlet weak var timestampSwitch: UISwitch!
    @IBOutlet weak var gravitySwitch: UISwitch!
    @IBOutlet weak var rotationSwitch: UISwitch!
    @IBOutlet weak var accelerationSwitch: UISwitch!
    @IBOutlet weak var cordinateSwitch: UISwitch!
    @IBOutlet weak var altitudeSwitch: UISwitch!
    @IBOutlet weak var attitudeSwitch: UISwitch!
    
    private lazy var refreshBarButton: UIBarButtonItem = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        return UIBarButtonItem(customView: activityIndicator)
    }()
    
    // MARK: Override method
    
    override func setupObservers() {
        super.setupObservers()
        
        // Display file name
        viewModel.$infomation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                var test = self?.titleTableViewCell.defaultContentConfiguration()
                test?.text = info
                self?.titleTableViewCell.contentConfiguration = test
            }
            .store(in: &cancellable)

        // Enable button if a switch is at least true
        viewModel.$enabledExportButton
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: exportButton)
            .store(in: &cancellable)
        
        // Sharing csv file
        viewModel.sharingCsvPathFile
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] path in
                self?.sharingCSV(filePath: path)
            }
            .store(in: &cancellable)
        
        // The switch is on if the timestamp value is true
        viewModel.$timestampValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: timestampSwitch)
            .store(in: &cancellable)
        
        // The switch is on if the gravity value is true
        viewModel.$gravityValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: gravitySwitch)
            .store(in: &cancellable)
        
        // The switch is on if the rotation value is true
        viewModel.$rotationValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: rotationSwitch)
            .store(in: &cancellable)
        
        // The switch is on if the acceleration value is true
        viewModel.$accelerationValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: accelerationSwitch)
            .store(in: &cancellable)
        
        // The switch is on if the altitude value is true
        viewModel.$altitudeValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: altitudeSwitch)
            .store(in: &cancellable)
        
        // The switch is on if the attitude value is true
        viewModel.$attitudeValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: attitudeSwitch)
            .store(in: &cancellable)
        
        // The switch is on if the cordinate value is true
        viewModel.$cordinateValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: cordinateSwitch)
            .store(in: &cancellable)
        
        // Disable altitude switch if there is no location
        viewModel.$enabledLocationValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: altitudeSwitch)
            .store(in: &cancellable)
        
        // Disable location switch if there is no location
        viewModel.$enabledLocationValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: cordinateSwitch)
            .store(in: &cancellable)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.loadAnimation(value)
            }
            .store(in: &cancellable)
        
    }
    
    // MARK: Action method
    
    @IBAction func dismissScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exportFile(_ sender: Any) {
        self.viewModel.exportCSV()
    }
    
    @IBAction func timestampChange(_ sender: UISwitch) {
        viewModel.timestampValue = sender.isOn
    }
    
    @IBAction func gravityChange(_ sender: UISwitch) {
        viewModel.gravityValue = sender.isOn
    }
    
    @IBAction func rotationChange(_ sender: UISwitch) {
        viewModel.rotationValue = sender.isOn
    }
    
    @IBAction func accelerationChange(_ sender: UISwitch) {
        viewModel.accelerationValue = sender.isOn
    }
    
    @IBAction func cordinateChange(_ sender: UISwitch) {
        viewModel.cordinateValue = sender.isOn
    }
    
    @IBAction func altitudeChange(_ sender: UISwitch) {
        viewModel.altitudeValue = sender.isOn
    }
    
    @IBAction func attitudeChange(_ sender: UISwitch) {
        viewModel.attitudeValue = sender.isOn
    }
    
    // MARK: Private method
    
    private func loadAnimation(_ value: Bool) {
        if value {
            navigationItem.rightBarButtonItem = refreshBarButton
        }else{
            navigationItem.rightBarButtonItem = exportButton
        }
        view.isUserInteractionEnabled = !value
    }
    
    private func sharingCSV(filePath: String) {
        
        let firstActivityItem = NSURL(fileURLWithPath: filePath)
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.markupAsPDF
        ]
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
