//
//  WKInterfaceTimer+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 31/01/2022.
//

import Foundation
import WatchKit

extension WKInterfaceTimer {
    
    private static var _isStart = [String:Bool]()
    var isStart: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceTimer._isStart[tmpAddress] ?? false
        }
        set {
            if newValue {
                start()
            }else{
                stop()
            }
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceTimer._isStart[tmpAddress] = newValue
        }
    }
    
    private static var _date = [String:Date]()
    var date: Date {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceTimer._date[tmpAddress] ?? Date()
        }
        set {
            setDate(newValue)
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceTimer._date[tmpAddress] = newValue
        }
    }
    
}
