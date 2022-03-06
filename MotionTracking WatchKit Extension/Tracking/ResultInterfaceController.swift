//
//  ResultInterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 20/01/2022.
//

import WatchKit
import Foundation

class ResultInterfaceController: BaseInterfaceController<ResultViewModel>  {
    
    @IBOutlet weak var gravityXLabel: WKInterfaceLabel!
    @IBOutlet weak var gravityYLabel: WKInterfaceLabel!
    @IBOutlet weak var gravityZLabel: WKInterfaceLabel!
    
    @IBOutlet weak var accelerationXLabel: WKInterfaceLabel!
    @IBOutlet weak var accelerationYLabel: WKInterfaceLabel!
    @IBOutlet weak var accelerationZLabel: WKInterfaceLabel!
    
    @IBOutlet weak var rotationXLabel: WKInterfaceLabel!
    @IBOutlet weak var rotationYLabel: WKInterfaceLabel!
    @IBOutlet weak var rotationZLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func setupObservers() {
        super.setupObservers()
        
        viewModel.$gravityX
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: gravityXLabel)
            .store(in: &cancellable)
        
        viewModel.$gravityY
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: gravityYLabel)
            .store(in: &cancellable)
        
        viewModel.$gravityZ
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: gravityZLabel)
            .store(in: &cancellable)
        
        viewModel.$accelerationX
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: accelerationXLabel)
            .store(in: &cancellable)
        
        viewModel.$accelerationY
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: accelerationYLabel)
            .store(in: &cancellable)
        
        viewModel.$accelerationZ
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: accelerationZLabel)
            .store(in: &cancellable)
        
        
        viewModel.$rotationX
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: rotationXLabel)
            .store(in: &cancellable)
        
        viewModel.$rotationY
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: rotationYLabel)
            .store(in: &cancellable)
        
        viewModel.$rotationZ
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: rotationZLabel)
            .store(in: &cancellable)
    }

}
