//
//  WKInterfaceLabel+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 01/02/2022.
//

import Foundation
import WatchKit

extension WKInterfaceLabel {
    
    private static var _text = [String:String]()
    var text: String {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceLabel._text[tmpAddress] ?? ""
        }
        set {
            setText(newValue)
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceLabel._text[tmpAddress] = newValue
        }
    }
    
}
