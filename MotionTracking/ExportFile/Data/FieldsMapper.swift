//
//  FieldsMapper.swift
//  MotionTracking
//
//  Created by Karim Angama on 26/02/2022.
//

import Foundation

struct FieldsMapper {
    
    static func mapper(_ motion: (Bool, Bool, Bool, Bool), _ location: (Bool, Bool)) -> CSVFileFields {
         CSVFileFields(
            timestamp: motion.0,
            gravityX: motion.1,
            gravityY: motion.1,
            gravityZ: motion.1,
            rotationRateX: motion.2,
            rotationRateY: motion.2,
            rotationRateZ: motion.2,
            attitudeRoll: motion.3,
            attitudePitch: motion.3,
            attitudeYaw: motion.3,
            latitude: location.0,
            longitude: location.0,
            altitude: location.1
        )
    }
    
}
