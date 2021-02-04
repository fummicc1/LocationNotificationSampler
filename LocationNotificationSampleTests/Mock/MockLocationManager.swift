//
//  MockLocationManager.swift
//  LocationNotificationSampleTests
//
//  Created by Fumiya Tanaka on 2021/02/05.
//

import Foundation
import CoreLocation

class MockLocationManager: CLLocationManager {
    var calledFunctions: Set<String> = []
    
    override init() {
        super.init()
        delegate = self
    }
}

extension MockLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        calledFunctions.insert(#function)
    }
}
