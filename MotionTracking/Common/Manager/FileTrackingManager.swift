//
//  FileTrackingManager.swift
//  MotionTracking
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation

/**
 Entity tracking file
 
 */
struct FileTrackingEntity {
    let name: String
    let date: Date
    let fileUrl: URL
    let isLocation: Bool
}

/**
 File Tracking manager
 
 */
class FileTrackingManager {
    
    struct Const {
        static let nameFile = "tracking-file"
        static let separation = "_"
        static let extensionCSV = ".csv"
        static let extensionTXT = ".txt"
        static let location = "location"
    }
    
    // MARK:  Public method
    
    /**
        Add file in the cache directory
     
        @param json - Tracking data
        @param withLocation - Specify if there is location in the data
        @retrun The file  url stored  in the cache directory
     */
    func writeFileTransfer(json: String, withLocation: Bool) throws -> URL {
        let fileName = nameOfTransferFile(withLocation: withLocation)
        let path = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("\(fileName)\(Const.extensionTXT)")
        try json.write(to: path, atomically: true, encoding: .utf8)
        return path
    }
    
    /**
        Move the file url stored in the cache directory to application support directory
     
        @param fileUrl - The file  url stored  in the cache directory
        @retrun Tracking files entity
     */
    func moveCachesToSupportDirectory(fileUrl: URL) throws -> FileTrackingEntity {
        let fileName = fileUrl.lastPathComponent
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        try FileManager.default.moveItem(atPath: fileUrl.path, toPath: url.path)
        return fileTracking(fileUrl: url)
    }
    
    /**
        Return all tracking files entities stored in application support directory
     
        @retrun Tracking files entities array
     */
    func filesTracking() -> [FileTrackingEntity] {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if let arrayFile = try? FileManager.default.contentsOfDirectory(atPath: url.path) {
            return arrayFile
                .filter { $0.contains(Const.extensionTXT) }
                .map { fileTracking(fileUrl: url.appendingPathComponent($0)) }
                .sorted {
                    $0.date.compare($1.date) == .orderedDescending
                }
        }
        return []
    }
    
    /**
        Remove file
     
        @param fileUrl - The file  url
     */
    func removeFile(fileUrl: URL) throws {
        try FileManager.default.removeItem(at: fileUrl)
    }
    
    // MARK: Private method
    
    /**
        Create and retourn the file name
     
        @Param withLocation - Add the location parameter in the file name
     */
    private func nameOfTransferFile(withLocation: Bool) -> String {
        let date = Date().nowDateIso8601
        let withLocation = withLocation ? "_\(Const.location)" : ""
        return "\(Const.nameFile)_\(date)\(withLocation)"
    }
    
    /**
        Create and return a entity with the file name
     
        @param fileUrl - The file  url
        @return  The entity file tracking
     */
    private func fileTracking(fileUrl: URL) -> FileTrackingEntity {
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        let array = fileName.components(separatedBy: Const.separation)
        return FileTrackingEntity(
            name: array.first ?? "untitled",
            date: Date.string(date: array[1]),
            fileUrl: fileUrl,
            isLocation: fileName.contains(Const.location)
        )
    }
    
}
