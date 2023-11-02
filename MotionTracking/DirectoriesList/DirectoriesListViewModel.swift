//
//  DirectoriesListViewModel.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import Foundation
import Combine
import UIKit

class DirectoriesListViewModel: BaseViewModel, ManagerInjector {
    
    /// Output observable
    var directoriesDidChange = PassthroughSubject<Void, Never>()
    
    /// Output property
    var directories = [String]()
    
    // MARK: Override method
    
    override func exeUseCase() {
        super.exeUseCase()
        getDirectoriesList()
        didFileAdded()
    }
    
    // MARK: Public method
    
    func selectedDirectory(index: Int) {
        fileTrackingManager.selectDirectory(name: directories[index])
    }
    
    // MARK: Private method
    
    private func getDirectoriesList() {
        let array = fileTrackingManager.directories()
        directories.append(contentsOf: array)
        directoriesDidChange.send()
    }

    private func didFileAdded() {
        fileTrackingManager.didFileAdded { entity, error in
            if let error = error {
                self.error(error)
            } else {
                // TODO update detail information
            }
        }
    }
    
}
