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
    var reloadRows = PassthroughSubject<Int, Never>()
    
    /// Input observable
    var removeFileEntity  = PassthroughSubject<FileTrackingEntity, Never>()
    
    /// Output property
    var directories = [DirectoryEntity]()
    
    // MARK: Override method
    
    override func exeUseCase() {
        super.exeUseCase()
        getDirectoriesList()
    }
    
    override func observers() {
        super.observers()
        
        removeFileEntity
            .sink { [weak self] entity in
                let index = self?.updateNumberDirectory(fileEntity: entity, value: -1)
                self?.reloadRows.send(index ?? 0)
            }
            .store(in: &cancellable)
    }
    
    // MARK: Public method
    
    func selectedDirectory(index: Int) {
        fileTrackingManager.selectDirectory(name: directories[index].name)
    }
    
    func didFileAdded() {
        fileTrackingManager.didFileAdded { [weak self] entity, error in
            if let error = error {
                self?.error(error)
            } else if let entity = entity {
                let index = self?.updateNumberDirectory(fileEntity: entity, value: 1)
                self?.reloadRows.send(index ?? 0)
            }
        }
    }
    
    // MARK: Private method
    
    private func getDirectoriesList() {
        let array = fileTrackingManager.directories()
        directories.append(contentsOf: array)
        directoriesDidChange.send()
    }
    
    private func updateNumberDirectory(fileEntity: FileTrackingEntity, value: Int) -> Int {
        directories = directories.map({ directory in
            if(fileEntity.fileUrl.absoluteString.contains(directory.name)) {
                return DirectoryEntity(
                    name: directory.name,
                    numberFile: directory.numberFile + value
                )
            }
            return directory
        })
        return directories.firstIndex {
            fileEntity.fileUrl.absoluteString.contains($0.name)
        } ?? 0
    }
    
}
