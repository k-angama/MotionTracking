//
//  ExportFileViewModelTests.swift
//  MotionTrackingTests
//
//  Created by Karim Angama on 19/03/2024.
//

import XCTest
@testable import MotionTracking

final class ExportFileViewModelTests: XCTestCase {

    var viewModel: ExportFileViewModel!
    
    override func setUpWithError() throws {
        viewModel = ExportFileViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_init_fields_all_true() throws {
        XCTAssertEqual(viewModel.fileManager.fields, CSVFileFields())
    }
    
    func test_gravity_is_false() throws {
        viewModel.observers()
        viewModel.gravityValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(gravityX: false, gravityY: false, gravityZ: false)
        )
    }
    
    func test_altitude_is_false() throws {
        viewModel.observers()
        viewModel.altitudeValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(locationAltitude: false)
        )
    }
    
    func test_cordinate_is_false() throws {
        viewModel.observers()
        viewModel.cordinateValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(locationLatitude: false, locationLongitude: false)
        )
    }
    
    func test_acceleration_is_false() throws {
        viewModel.observers()
        viewModel.accelerationValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(
                userAccelerationX: false,
                userAccelerationY: false,
                userAccelerationZ: false
            )
        )
    }
    
    func test_rotation_is_false() throws {
        viewModel.observers()
        viewModel.rotationValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(
                rotationRateX: false,
                rotationRateY: false,
                rotationRateZ: false
            )
        )
    }
    
    func test_attitude_is_false() throws {
        viewModel.observers()
        viewModel.attitudeValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(
                attitudeRoll: false,
                attitudePitch: false,
                attitudeYaw: false
            )
        )
    }
    
    func test_timestamp_is_false() throws {
        viewModel.observers()
        viewModel.timestampValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(timestamp: false)
        )
    }
    
    func test_rotation_and_acceleration_is_false() throws {
        viewModel.observers()
        viewModel.rotationValue = false
        viewModel.accelerationValue = false
        XCTAssertEqual(
            viewModel.fileManager.fields,
            CSVFileFields(
                rotationRateX: false,
                rotationRateY: false,
                rotationRateZ: false,
                userAccelerationX: false,
                userAccelerationY: false,
                userAccelerationZ: false
            )
        )
    }

}
