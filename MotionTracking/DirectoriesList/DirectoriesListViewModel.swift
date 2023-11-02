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
        UIApplication.app().connectivityManager.delegate = self
        getDirectoriesList()
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

    private func addFile(file: URL) {
        do {
            _ = try fileTrackingManager.moveCachesToSupportDirectory(fileUrl: file)
        } catch {
            self.error(error)
        }
    }
    
}


// MARK: Connectivity Manager Delegate

extension DirectoriesListViewModel: ConnectivityManagerDelegate {
    
    func didReceiveFile(file: URL) {
        addFile(file: file)
    }
    
}
