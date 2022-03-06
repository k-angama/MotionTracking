//
//  InterfaceImage+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import WatchKit

extension WKInterfaceImage {
    
    private static var _isLoaderIndicator = [String:Bool]()
    var isLoaderIndicator: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceImage._isLoaderIndicator[tmpAddress] ?? false
        }
        set {
            if newValue {
                startLoaderIndicator()
            }else{
                stopLoaderIndicator()
            }
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceImage._isLoaderIndicator[tmpAddress] = newValue
        }
    }
    
    func startLoaderIndicator() {
        setImageNamed("spinner")
        setHidden(false)
        startAnimatingWithImages(in: NSMakeRange(1, 8), duration: 0.5, repeatCount: 0)
    }
    
    func stopLoaderIndicator() {
        setHidden(true)
        stopAnimating()
    }
    
}
