//
//  BaseViewModel.swift
//  MotionTracking
//
//  Created by Karim Angama on 03/02/2022.
//

import Foundation
import Combine

protocol ViewModel {
    func setup()
    func exeUseCase()
    func observers()
}

protocol Router {
    associatedtype T
}

class BaseRouter {
    
}

class BaseViewModel: ViewModel {
    
    /// For memory management and subscriptions cancellations
    var cancellable = Set<AnyCancellable>()
 
    /// Error observable
    private(set) var error = PassthroughSubject<Error, Never>()
    
    
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
     * Add Observers in the view model
     */
    func observers() {}
    
    /**
     * Manage code error
     */
    func error(_ error: Error) {
        self.error.send(error)
    }
    
}
