//
//  WKInterfaceSwitch+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation
import WatchKit

extension WKInterfaceSwitch {
    
    private static var _on = [String:Bool]()
    var on: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceSwitch._on[tmpAddress] ?? false
        }
        set {
            setOn(newValue)
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceSwitch._on[tmpAddress] = newValue
        }
    }
    
}
