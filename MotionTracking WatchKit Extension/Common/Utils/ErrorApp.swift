//
//  ErrorApp.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 01/02/2022.
//

import Foundation

struct ErrorApp: Error {
    
    let title: String?
    let description: String?
    
    init(title: String? = nil, description: String? = nil) {
        self.title = title
        self.description = description
    }
    
}
