//
//  FilesListViewModel.swift
//  MotionTracking
//
//  Created by Karim Angama on 03/02/2022.
//

import Foundation
import Combine
import UIKit

class FilesListViewModel: BaseViewModel {
    
    // Property
    var fileTrackingManager = FileTrackingManager()
    
    /// Output observable
    @Published var hiddenTextNoFile = false
    var filesDidChange = PassthroughSubject<Void, Never>()
    var removeFile = PassthroughSubject<Int, Never>()
    var inserFile = PassthroughSubject<Void, Never>()
    
    /// Output property
    var files = [FileTrackingEntity]()
    
    
    // MARK: Override method
    
    override func exeUseCase() {
        super.exeUseCase()
        getFilesList()
        UIApplication.app().connectivityManager.delegate = self
    }
    
    override func observers() {
        super.observers()
        
        // Hide the message if there is a list of files
        Publishers.Merge3(
            filesDidChange,
            removeFile.map { _ in () },
            inserFile
        )
        .map { [weak self] _ in
            self?.files.count ?? 0 > 0
        }
        .assign(to: \.hiddenTextNoFile, on: self)
        .store(in: &cancellable)
        
    }
    
    // MARK: Public method
    
    func addFile(file: URL) {
        do {
            let entity = try fileTrackingManager.moveCachesToSupportDirectory(fileUrl: file)
            files.insert(entity, at: 0)
            inserFile.send()
        } catch {
            self.error(error)
        }
    }
    
    func reloadFiles() {
        files.removeAll()
        getFilesList()
    }
    
    func removeFile(index: Int) {
        do {
            try fileTrackingManager.removeFile(fileUrl: files[index].fileUrl)
            files.remove(at: index)
            removeFile.send(index)
        } catch {
            self.error(error)
        }
    }
    
    // MARK: Private method
    
    private func getFilesList() {
        let arrayFiles = fileTrackingManager.filesTracking()
        files.append(contentsOf: arrayFiles)
        filesDidChange.send()
    }

}

// MARK: Connectivity Manager Delegate

extension FilesListViewModel: ConnectivityManagerDelegate {
    
    func didReceiveFile(file: URL) {
        addFile(file: file)
    }
    
}
