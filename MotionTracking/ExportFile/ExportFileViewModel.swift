//
//  ExportFileViewModel.swift
//  MotionTracking
//
//  Created by Karim Angama on 05/02/2022.
//

import Foundation
import Combine

class ExportFileViewModel: BaseViewModel {
    
    /// Properties
    let fileManager = CSVFileManager()
    
    /// Output
    @Published var fileName: String?
    @Published var fileTrackingEntity: FileTrackingEntity?
    @Published var enabledExportButton = false
    
    // Input
    @Published var gravityValue = true
    @Published var timestampValue = true
    @Published var rotationValue = true
    @Published var accelerationValue = true
    @Published var cordinateValue = true
    @Published var altitudeValue = true
    @Published var enabledLocationValue = true
    @Published var sharingCsvPathFile = PassthroughSubject<String, Never>()
    
    
    // MARK: Override method
    
    override func observers() {
        super.observers()
        
        // Disable location switches if they are not present in the file
        $fileTrackingEntity
            .sink { [weak self] entity in
                if let isLocation = entity?.isLocation, !isLocation {
                    self?.cordinateValue = false
                    self?.altitudeValue = false
                    self?.enabledLocationValue = false
                }
            }
            .store(in: &cancellable)
        
        // Pass the file name to display it
        $fileTrackingEntity
            .sink { [weak self] entity in
                self?.fileName = entity?.name ?? ""
            }
            .store(in: &cancellable)
        
        // Test if a switch is at least true
        combineSwitchValue()
        .eraseToAnyPublisher()
        .map { (motion, location) in
            motion.0 || motion.1 || motion.2 || motion.3 ||
            location.0 || location.1
        }
        .removeDuplicates()
        .assign(to: &$enabledExportButton)
        
        // Set fields for create the CSV
        combineSwitchValue()
        .eraseToAnyPublisher()
        .map(FieldsMapper.mapper)
        .sink { [weak self] fields in
            self?.fileManager.setFiels(fields: fields)
        }
        .store(in: &cancellable)

    }
    
    // MARK: Public method
    
    func exportCSV() {
        guard let fileURL = fileTrackingEntity?.fileUrl else { return }
        do {
            let path = try fileManager.save(fileUrl: fileURL)
            sharingCsvPathFile.send(path)
        } catch {
            self .error(error)
        }
    }
    
    // MARK: Private method
    
    private func combineSwitchValue() -> Publishers.CombineLatest<Publishers.CombineLatest4<Published<Bool>.Publisher, Published<Bool>.Publisher, Published<Bool>.Publisher, Published<Bool>.Publisher>, Publishers.CombineLatest<Published<Bool>.Publisher, Published<Bool>.Publisher>> {
        Publishers.CombineLatest(
            Publishers.CombineLatest4(
                $timestampValue,
                $gravityValue,
                $rotationValue,
                $accelerationValue
            ),
            Publishers.CombineLatest(
                $cordinateValue,
                $altitudeValue
            )
        )
        
    }

}
