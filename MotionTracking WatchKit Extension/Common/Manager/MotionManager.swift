//
//  MotionManager.swift
//  MotionTracking WatchKit Extension
//
//  Created by Karim Angama on 19/01/2022.
//

import Foundation
import CoreMotion
import WatchKit
import os.log

/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
  These contexts can be used to enable application specific behavior.
 */
protocol MotionManagerDelegate: AnyObject {
    func didUpdateMotion(_ manager: MotionManager, result: ResultMotionEnity)
}

/**
 `LocationManagerDelegate` exists to inform delegates of use the authorization of location.
 */
protocol LocationManagerDelegate: AnyObject {
    
    /// Return yes, if user authorized
    func userAuthorization(response: Bool)
}

/**
 `ResultMotionEnity` motion and location data
 */
struct ResultMotionEnity: Encodable {
    let timestamp: Double
    let gravityX: Double
    let gravityY: Double
    let gravityZ: Double
    let userAccelerationX: Double
    let userAccelerationY: Double
    let userAccelerationZ: Double
    let rotationRateX: Double
    let rotationRateY: Double
    let rotationRateZ: Double
    let attitudeRoll: Double
    let attitudePitch: Double
    let attitudeYaw: Double
    var locationLatitude: Double?
    var locationLongitude: Double?
    var locationAltitude: Double?
    
    init(timestamp: Double, gravityX: Double, gravityY: Double, gravityZ: Double,
         userAccelerationX: Double, userAccelerationY: Double, userAccelerationZ: Double,
         rotationRateX: Double, rotationRateY: Double, rotationRateZ: Double,
         attitudeRoll: Double, attitudePitch: Double, attitudeYaw: Double,
         latitude: Double? = nil, longitude: Double? = nil, altitude: Double? = nil) {
        self.timestamp = timestamp
        self.gravityX = gravityX
        self.gravityY = gravityY
        self.gravityZ = gravityZ
        self.userAccelerationX = userAccelerationX
        self.userAccelerationY = userAccelerationY
        self.userAccelerationZ = userAccelerationZ
        self.rotationRateX = rotationRateX
        self.rotationRateY = rotationRateY
        self.rotationRateZ = rotationRateZ
        self.attitudeRoll = attitudeRoll
        self.attitudePitch = attitudePitch
        self.attitudeYaw = attitudeYaw
        self.locationLatitude = latitude
        self.locationLongitude = longitude
        self.locationAltitude = altitude
    }
}

/**
 `MotionManager`  manage the motion and location
 */
class MotionManager: NSObject {
    // MARK: Properties
    
    
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left

    // MARK: Application Specific Constants
    
    /// The app is using 50hz data.
    private var sampleInterval: Double
    
    /// Add data location
    private var addDataLocation: Bool
    
    // MARK: Public properties
    
    weak var delegate: MotionManagerDelegate?
    weak var delegateLocation: LocationManagerDelegate?
    
    // Array motion entities
    private(set) var resultMotion:[ResultMotionEnity] = []

    
    // MARK: Initialization
    
    required init(sampleInterval: Double, addDataLocation: Bool) {
        self.sampleInterval = 1.0 / sampleInterval
        self.addDataLocation = addDataLocation
        
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
        
        // Setup location
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
    }
    
    // MARK: Motion Location
    
    /**
     Request Always Authorization
     */
    func authorization() {
        locationManager.delegate = self
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.requestAlwaysAuthorization()
        }
    }
    
    /**
     Start the location for start tracking in background
     */
    func startLocation() {
        locationManager.startUpdatingLocation()
    }

    private func stopLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    // MARK: Motion Manager

    /**
     Start device motion updates
     */
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            // TODO error managment
            return
        }

        resultMotion.removeAll()
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
                // TODO error managment
            }

            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
        }
    }

    /**
     Stop device motion updates
     */
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
        stopLocation()
    }

    // MARK: Motion Processing
    
    private func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        
        let timestamp = Date().timeIntervalSince1970
        
        var motionEnity = ResultMotionEnity(
            timestamp : timestamp,
            gravityX: deviceMotion.gravity.x,
            gravityY: deviceMotion.gravity.y,
            gravityZ: deviceMotion.gravity.z,
            userAccelerationX: deviceMotion.userAcceleration.x,
            userAccelerationY: deviceMotion.userAcceleration.y,
            userAccelerationZ: deviceMotion.userAcceleration.z,
            rotationRateX: deviceMotion.rotationRate.x,
            rotationRateY: deviceMotion.rotationRate.y,
            rotationRateZ: deviceMotion.rotationRate.z,
            attitudeRoll: deviceMotion.attitude.roll,
            attitudePitch: deviceMotion.attitude.pitch,
            attitudeYaw: deviceMotion.attitude.yaw
        )
        
        // If yes, add location to data
        if addDataLocation {
            motionEnity.locationLatitude = locationManager.location?.coordinate.latitude
            motionEnity.locationLongitude = locationManager.location?.coordinate.longitude
            motionEnity.locationAltitude = locationManager.location?.altitude
        }
        
        resultMotion.append(motionEnity)
        
        os_log("Motion: %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
               String(timestamp),
               String(deviceMotion.gravity.x),
               String(deviceMotion.gravity.y),
               String(deviceMotion.gravity.z),
               String(deviceMotion.userAcceleration.x),
               String(deviceMotion.userAcceleration.y),
               String(deviceMotion.userAcceleration.z),
               String(deviceMotion.rotationRate.x),
               String(deviceMotion.rotationRate.y),
               String(deviceMotion.rotationRate.z),
               String(deviceMotion.attitude.roll),
               String(deviceMotion.attitude.pitch),
               String(deviceMotion.attitude.yaw),
               String(locationManager.location?.coordinate.latitude ?? 0.0),
               String(locationManager.location?.coordinate.longitude ?? 0.0),
               String(locationManager.location?.altitude ?? 0.0))
        
        updateMetricsDelegate(motion: motionEnity);
    }

    // MARK: Data and Delegate Management
    
    private func updateMetricsDelegate(motion: ResultMotionEnity) {
        delegate?.didUpdateMotion(self, result:motion)
    }
}

extension MotionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        self.delegateLocation?.userAuthorization(response: status == .authorizedAlways || status == .authorizedWhenInUse)
    }

}
