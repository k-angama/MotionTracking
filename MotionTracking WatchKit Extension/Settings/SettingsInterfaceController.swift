//
//  SettingsInterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 21/01/2022.
//

import WatchKit
import Foundation

class SettingsInterfaceController: BaseInterfaceController<SettingsViewModel>  {
    
    @IBOutlet weak var interfacePicker: WKInterfacePicker!
    @IBOutlet weak var herzInterfaceSlider: WKInterfaceSlider!
    @IBOutlet weak var herzInterfaceLabel: WKInterfaceLabel!
    @IBOutlet weak var locationInterfaceSwitch: WKInterfaceSwitch!
    
    
    // MARK: Override method
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupPicker()
    }
    
    override func setupObservers() {
        super.setupObservers()
        
        // Set herz value to slider
        viewModel.$herzValue
            .receive(on: DispatchQueue.main)
            .map { Float($0) }
            .assign(to: \.value, on: herzInterfaceSlider)
            .store(in: &cancellable)
        
        // Set timer value to picker
        viewModel.indexPickerValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedItemIndex, on: interfacePicker)
            .store(in: &cancellable)
        
        // Display herz
        viewModel.$herzValue
            .receive(on: DispatchQueue.main)
            .map { "\(Int($0))" }
            .assign(to: \.text, on: herzInterfaceLabel)
            .store(in: &cancellable)
        
        viewModel.$locationValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.on, on: locationInterfaceSwitch)
            .store(in: &cancellable)
        
    }
    
    // MARK: Action method
    
    @IBAction func sliderAction(_ value: Float) {
        viewModel.herzValue = Double(value)
    }
    
    @IBAction func pickerAction(_ value: Int) {
        viewModel.indexPickerValue.send(value)
    }
    
    @IBAction func switchAction(_ value: Bool) {
        viewModel.locationValue = value
    }
    
    // MARK: Private method
    
    private func setupPicker() {
        
        let item = viewModel.timeRange
            .compactMap({ index -> WKPickerItem in
                let pickerItem = WKPickerItem()
                pickerItem.title = "\(index)s"
                pickerItem.caption = "Second"
                return pickerItem
            })
        interfacePicker.setItems(item)
        
    }

}
