//
//  BaseTableViewController.swift
//  MotionTracking
//
//  Created by Karim Angama on 05/02/2022.
//

import Foundation
import Combine
import UIKit

class BaseTableViewController<T: BaseViewModel>: UITableViewController, ViewController {
    
    /// For memory management and subscriptions cancellations
    var cancellable = Set<AnyCancellable>()
    
    /// ViewModel of ViewController
    var viewModel: T!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = T.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupObservers()
        viewModel.observers()
        viewModel.exeUseCase()
    }
    
    /**
     * Set data binding in the view controller
     */
    func setupBindings() {}
    
    /**
     * Set Observers in the view controller
     */
    func setupObservers() {
        
        // Display error message
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showMessageError(error)
            }
            .store(in: &cancellable)
        
        
    }
    
    /**
     * Manage user interface here
     */
    func setupUI() {}
    
}
