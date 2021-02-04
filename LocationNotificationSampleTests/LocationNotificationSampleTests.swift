//
//  LocationNotificationSampleTests.swift
//  LocationNotificationSampleTests
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import XCTest
@testable import LocationNotificationSample

class LocationNotificationSampleTests: XCTestCase {

    let locationManager = MockLocationManager()
    let notificationCenter = MockNotificationCenter
    
    lazy var model: MapModelType = MapModel(locationManager: mockLocationManager, notificationCenter: notificationCenter)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
