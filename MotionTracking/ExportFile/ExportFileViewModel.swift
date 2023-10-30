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
    @Published var infomation: String?
    @Published var fileTrackingEntity: [FileTrackingEntity] = []
    @Published var enabledExportButton = false
    
    // Input
    @Published var gravityValue = true
    @Published var timestampValue = true
    @Published var rotationValue = true
    @Published var accelerationValue = true
    @Published var cordinateValue = true
    @Published var altitudeValue = true
    @Published var enabledLocationValue = true
    @Published var isLoading = false
    @Published var sharingCsvPathFile = PassthroughSubject<String, Never>()
    
    
    // MARK: Override method
    
    override func observers() {
        super.observers()
        
        // Disable location switches if they are not present in the file
        $fileTrackingEntity
            .sink { [weak self] entity in
                if let isLocation = entity.first?.isLocation, !isLocation {
                    self?.cordinateValue = false
                    self?.altitudeValue = false
                    self?.enabledLocationValue = false
                }
            }
            .store(in: &cancellable)
        
        // Pass the information file to display it
        $fileTrackingEntity
            .sink { [weak self] entities in
                self?.infomation = self?.information(entities)
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
        isLoading = true
        if self.fileTrackingEntity.count > 1 {
            self.fileManager.save(
                filesUrl: self.fileTrackingEntity.map { $0.fileUrl },
                block: { zipPath, error in
                    if let error = error {
                        self.error(error)
                    } else {
                        self.sharingCsvPathFile.send(zipPath)
                    }
                    self.isLoading = false
                }
            )
        } else {
            guard let fileURL = fileTrackingEntity.first?.fileUrl else { return }
            self.fileManager.save(fileUrl: fileURL) { csvPath, error in
                if let error = error {
                    self.error(error)
                } else if let csvPath = csvPath {
                    self.sharingCsvPathFile.send(csvPath)
                }
                self.isLoading = false
            }
        }
    }
    
    // MARK: Private method
    
    private func information(_ entities: [FileTrackingEntity]) -> String{
        if entities.count == 1 {
            return entities.first?.information ?? ""
        }
        return "Files to export: \(entities.count)"
    }
    
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
