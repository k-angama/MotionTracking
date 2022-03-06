//
//  WKInterfacePicker+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation
import WatchKit

extension WKInterfacePicker {
    
    private static var _selectedItemIndex = [String:Int]()
    var selectedItemIndex: Int {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfacePicker._selectedItemIndex[tmpAddress] ?? 0
        }
        set {
            setSelectedItemIndex(newValue)
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfacePicker._selectedItemIndex[tmpAddress] = newValue
        }
    }
    
}
