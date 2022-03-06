//
//  Parameters.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 01/02/2022.
//

import Foundation

struct Parameters {
    
    struct Keys {
        static let motionIntervalConfiguration  = "com.kangama.herz-configuration"
        static let timerConfiguration  = "com.kangama.timer-configuration"
        static let locationConfiguration  = "com.kangama.location-configuration"
    }
    
    static func getMotionInterval() -> Double {
        let value = UserDefaults.standard.double(forKey: Keys.motionIntervalConfiguration)
        return value == 0 ? Constants.Configuration.initialMotionInterval : value
    }
    static func setMotionInterval(value: Double) {
        UserDefaults.standard.set(value, forKey:Keys.motionIntervalConfiguration)
    }
    
    static func getTimer() -> Double {
        let value = UserDefaults.standard.double(forKey: Keys.timerConfiguration)
        return value == 0 ? Constants.Configuration.initialTimer : value
    }
    static func setTimer(value: Double) {
        UserDefaults.standard.set(value, forKey:Keys.timerConfiguration)
    }
    
    static func getLocation() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.locationConfiguration)
    }
    static func setLocation(value: Bool) {
        UserDefaults.standard.set(value, forKey:Keys.locationConfiguration)
    }
    
}
