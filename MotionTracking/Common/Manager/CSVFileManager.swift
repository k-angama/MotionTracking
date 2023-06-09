//
//  CSVFileManager.swift
//  MotionTracking
//
//  Created by Karim Angama on 23/02/2022.
//

import Foundation
import SwiftCSVExport
import SSZipArchive

/**
 Entity CSV file fields
 
 */
struct CSVFileFields: Codable {
    
    let timestamp: Bool
    let gravityX: Bool
    let gravityY: Bool
    let gravityZ: Bool
    let rotationRateX: Bool
    let rotationRateY: Bool
    let rotationRateZ: Bool
    let attitudeRoll: Bool
    let attitudePitch: Bool
    let attitudeYaw: Bool
    let locationLatitude: Bool
    let locationLongitude: Bool
    let locationAltitude: Bool
    
    /// Convert the entity to dictionary
    var dictionary: [String: Bool]? {
        let json = JSONEncoder()
        guard let data = try? json.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments)
        )
            .flatMap { $0 as? [String: Bool] }
    }
    
    init(timestamp: Bool = true,
         gravityX: Bool = true,
         gravityY: Bool = true,
         gravityZ: Bool = true,
         rotationRateX: Bool = true,
         rotationRateY: Bool = true,
         rotationRateZ: Bool = true,
         attitudeRoll: Bool = true,
         attitudePitch: Bool = true,
         attitudeYaw: Bool = true,
         latitude: Bool = true,
         longitude: Bool = true,
         altitude: Bool = true
    ) {
        self.timestamp = timestamp
        self.gravityX = gravityX
        self.gravityY = gravityY
        self.gravityZ = gravityZ
        self.rotationRateX = rotationRateX
        self.rotationRateY = rotationRateY
        self.rotationRateZ = rotationRateZ
        self.attitudeRoll = attitudeRoll
        self.attitudePitch = attitudePitch
        self.attitudeYaw = attitudeYaw
        self.locationLatitude = latitude
        self.locationLongitude = longitude
        self.locationAltitude = altitude
    }
}

/**
 CSV file manager
 
 */
class CSVFileManager {
    
    var fields = CSVFileFields()
    
    // MARK: Public method

    /**
        Set the fields to add in the csv file
     
        @param fields - entity
     */
    func setFiels(fields: CSVFileFields) {
        self.fields = fields
    }
    
    /**
        Create and save the several file csv
     
        @param block - The file url stored  in the application support directory
     */
    func save(fileUrl: URL, block: @escaping (_ zipPath: String?, _ error: Error?) -> Void) {
        let backgroundQ = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        
        var errorSave: Error?
        var filePath: String?
        backgroundQ.async(group: group, execute: { [weak self] in
            do {
                filePath = try self?.save(fileUrl: fileUrl)
            } catch {
                errorSave = error
            }
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            block(filePath, errorSave)
        })
    }
    
    /**
        Create and save the several files csv
     
        @param block - The file url stored  in the application support directory
     */
    func save(filesUrl: [URL], block: @escaping (_ zipPath: String, _ error: Error?) -> Void) {
        var errorSave: Error?
        let backgroundQ = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        
        let zipPath = tempZipPath()
        var filePath: [String] = []
        backgroundQ.async(group: group, execute: { [weak self] in
            for file in filesUrl {
                do {
                    guard let path = try self?.save(fileUrl: file) else { return }
                    filePath.append(path)
                } catch {
                    errorSave = error
                }
            }
        })
        group.notify(queue: DispatchQueue.main, execute: {
            SSZipArchive.createZipFile(atPath: zipPath, withFilesAtPaths: filePath)
            block(zipPath, errorSave)
        })
        
    }
    
    // MARK: Private method
    
    private func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(nameOfZipFile()).zip"
        return path
    }
    
    /**
        Create and save the file csv
     
        @param fileUrl - The file url stored  in the application support directory
     */
    private func save(fileUrl: URL) throws -> String {
        let json = try String(contentsOf: fileUrl)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        print(fileName)
        let fields = getFields()
        return CSVExport.exportWithString(
            fileName,
            fields: fields,
            values: json
        ).filePath
        
    }
    
    /**
        Create and return the name file
     */
    private func nameOfZipFile() -> String {
        let date = Date().nowDateIso8601
        return "motionTracking_\(date)"
    }
    
    /**
     Return the array fields to add in the csv file
     
     @return   Array fields
     */
    private func getFields() -> [String] {
        guard let dic = fields.dictionary else { return [] }
        return dic.compactMap{
            if $1 { return $0 }
            return nil
        }.sorted().reversed()
    }
    
}
