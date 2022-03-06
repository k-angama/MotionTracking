//
//  ConnectivityManager.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 20/01/2022.
//

import Foundation
import WatchConnectivity
import CoreText

/**
 `ConnectivityManagerDelegate` exists to inform delegates of receive and finish transfer file.
 */
@objc protocol ConnectivityManagerDelegate: AnyObject {
    
    /// Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch.
    @objc optional func didReceiveFile(file: URL)
    
    /// Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished
    @objc optional func didFinishFileTransfer(error: Error?)
}

/**
 `ConnectivityManager` manage the transfer of files

 */
class ConnectivityManager: NSObject {
    
    /// Session Watch Connectivity
    private var session = WCSession.default
    
    /// Yes if the transfer is in progress
    private(set) var isFileTransfer = false

    /// Delegate inform of receive and finish transfer file
    weak var delegate: ConnectivityManagerDelegate?
    
    
    /**
     Initialization
     
     Activate transfert session
     */
    override init() {
        super.init()
        if !WCSession.isSupported() {
            print("Session is not available.")
            // TODO error managment
            return
        }
        session.delegate = self
        session.activate()
    }
    
    /**
     Transfer file to iPhone
     
     @param Url txt file
     */
    func sendFile(file: URL) {
        let value = session.transferFile(file, metadata: nil)
        isFileTransfer = value.isTransferring
    }
    
}

extension ConnectivityManager: WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("activationDidComplete: \(activationState.rawValue), error: \(String(describing: error))")
        // TODO error managment
    }

    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        isFileTransfer = false
        guard let didFinishFileTransfer = delegate?.didFinishFileTransfer else { return }
        didFinishFileTransfer(error)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        guard let didReceiveFile = delegate?.didReceiveFile else { return }
        didReceiveFile(file.fileURL)
    }
    
}
