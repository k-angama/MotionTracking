//
//  BaseInterfaceController.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 20/01/2022.
//

import WatchKit
import Foundation
import Combine

protocol InterfaceController {
    func setupObservers()
    func setupUI()
}

class BaseInterfaceController<T: BaseViewModel>: WKInterfaceController, InterfaceController {
    
    /// For memory management and subscriptions cancellations
    var cancellable = Set<AnyCancellable>()
    
    /// ViewModel of  InterfaceController
    var viewModel: T!
    
    
    override init() {
        super.init()
        self.viewModel = T.init()
        
        setupUI()
        setupObservers()
        viewModel.setup()
        viewModel.observers()
        viewModel.exeUseCase()
        
    }
    
    override func awake(withContext context: Any?) {
        
        // Push context to ViewModel
        if let context = context {
            viewModel.context(object: context)
        }

    }
    
    /**
     * Set Observers in the InterfaceController
     */
    func setupObservers() {}
    
    /**
     * Manage user interface here
     */
    func setupUI() {}
    
}
