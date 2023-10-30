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
struct FileTrackingEntity: Equatable {
    let information: String
    let date: Date
    let fileUrl: URL
    let isLocation: Bool
    
    static func ==(lhs: FileTrackingEntity, rhs: FileTrackingEntity) -> Bool {
        return lhs.information == rhs.information &&
        lhs.date.compare(rhs.date) == .orderedSame &&
        lhs.fileUrl.absoluteString == rhs.fileUrl.absoluteString &&
        lhs.isLocation == rhs.isLocation
    }
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
        @param location - Specify if there is location in the data
        @param time - Specify recording time
        @param count - Specify data count
        @retrun The file  url stored  in the cache directory
     */
    func writeFileTransfer(
        json: String,
        location: Bool,
        time: Double,
        count: Int) throws -> URL {
            let fileName = nameOfTransferFile(withLocation: location, second: time, count: count)
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

        var arrayFile: [String]? = nil
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
#if targetEnvironment(simulator)
        arrayFile = [
            "\(nameOfTransferFile(withLocation: false, second: 5, count: 200))\(Const.extensionTXT)",
            "\(nameOfTransferFile(withLocation: true, second: 10, count: 576))\(Const.extensionTXT)",
            "\(nameOfTransferFile(withLocation: false, second: 3, count: 187))\(Const.extensionTXT)",
            "\(nameOfTransferFile(withLocation: false, second: 10, count: 583))\(Const.extensionTXT)",
            "\(nameOfTransferFile(withLocation: false, second: 8, count: 370))\(Const.extensionTXT)",
            "\(nameOfTransferFile(withLocation: true, second: 12, count: 600))\(Const.extensionTXT)",
        ]
#else
        arrayFile = try? FileManager.default.contentsOfDirectory(atPath: url.path)
#endif
        return arrayFile?
            .filter { $0.contains(Const.extensionTXT) }
            .map { fileTracking(fileUrl: url.appendingPathComponent($0)) }
            .sorted {
                $0.date.compare($1.date) == .orderedDescending
            } ?? []
        
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
        Create and return the name file
     
        @Param withLocation - Add the location parameter in the file name
     */
    private func nameOfTransferFile(withLocation: Bool, second: Double, count: Int) -> String {
        let date = Date().nowDateIso8601
        let withLocation = withLocation ? "\(Const.separation)\(Const.location)" : ""
        let information = "\(second.time)\(Const.separation)\(count)"
        return "\(Const.nameFile)\(Const.separation)\(date)\(withLocation)\(Const.separation)\(information)"
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
            information: trackingInformation(array),
            date: Date.string(date: array[1]),
            fileUrl: fileUrl,
            isLocation: fileName.contains(Const.location)
        )
    }
    
    private func trackingInformation(_ array: [String]) -> String {
        array.count >= 4 ? "\(array[array.endIndex - 2]) - \(array.last ?? "-") records" : "No information"
    }
    
}
