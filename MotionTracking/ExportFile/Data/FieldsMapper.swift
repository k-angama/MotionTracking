//
//  FieldsMapper.swift
//  MotionTracking
//
//  Created by Karim Angama on 26/02/2022.
//

import Foundation

struct FieldsMapper {
    
    static func mapper(_ motion: (Bool, Bool, Bool, Bool, Bool), _ location: (Bool, Bool)) -> CSVFileFields {
         CSVFileFields(
            timestamp: motion.0,
            gravityX: motion.1,
            gravityY: motion.1,
            gravityZ: motion.1,
            rotationRateX: motion.2,
            rotationRateY: motion.2,
            rotationRateZ: motion.2,
            userAccelerationX: motion.3,
            userAccelerationY: motion.3,
            userAccelerationZ: motion.3,
            attitudeRoll: motion.4,
            attitudePitch: motion.4,
            attitudeYaw: motion.4,
            locationLatitude: location.0,
            locationLongitude: location.0,
            locationAltitude: location.1
        )
    }
    
}
