//
//  BaseViewModel.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    func exeUseCase()
    func observers()
    func context(object: Any?)
}

class BaseViewModel: ViewModelProtocol {
    
    /// For memory management and subscriptions cancellations
    var cancellable = Set<AnyCancellable>()
    
    /// Pass context object
    private(set) var context: Any?


    required init() {}
    
    /**
     * Setup here
     */
    func setup() {}
    
    /**
     * Add use case observable  in the function
     */
    func exeUseCase() {}
    
    /**
     * Add Observers
     */
    func observers() {}
    
    /**
     * context from controller that did push or modal presentation.
     *
     * @param context object passed
     */
    func context(object: Any?) {}
    
}
