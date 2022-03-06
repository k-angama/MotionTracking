//
//  WKInterfaceSlider+Extention.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation
import WatchKit

extension WKInterfaceSlider {
    
    private static var _text = [String:Float]()
    var value: Float {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return WKInterfaceSlider._text[tmpAddress] ?? 0.0
        }
        set {
            setValue(newValue)
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            WKInterfaceSlider._text[tmpAddress] = newValue
        }
    }
    
}
