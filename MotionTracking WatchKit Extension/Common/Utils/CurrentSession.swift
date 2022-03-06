//
//  CurrentSession.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 02/02/2022.
//

import Foundation

class CurrentSession {
    
    private(set) static var numberFileSending = 0
    private(set) static var numberFileError = 0
    
    static func addNumberFileSending() -> Int {
        numberFileSending = numberFileSending + 1
        return numberFileSending
    }
    
    static func addNumberFileError() -> Int {
        numberFileError =  numberFileError + 1
        return numberFileError
    }
}
