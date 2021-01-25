//
//  MapModel.swift
//  LocationNotificationSample
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import Foundation
import CoreLocation
import SwiftyUserDefaults

protocol MapModelType {
    var currentLocation: CLLocation? { get }
    var favoriteLocations: [Location] { get }
    func addFavoriteLocation(_ location: Location)
}

class MapModel: NSObject, CLLocationManagerDelegate, MapModelType {
    private let locationManager: CLLocationManager
    private let notificationCenter: NotificationCenter
    
    var currentLocation: CLLocation?
    var favoriteLocations: [Location] = []
    var favoriteLocationsObservation: DefaultsDisposable?
    
    init(locationManager: CLLocationManager, notificationCenter: NotificationCenter) {
        self.locationManager = locationManager
        self.notificationCenter = notificationCenter
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        favoriteLocationsObservation = Defaults.observe(\.favoriteLocationsKey) { [weak self] update in
            guard let newValue = update.newValue else {
                return
            }
            self?.favoriteLocations = newValue
            self?.notificationCenter.post(.init(name: .favoriteLocations))
        }
        favoriteLocations = Defaults[\.favoriteLocationsKey]
    }
    
    func addFavoriteLocation(_ location: Location) {
        var current = favoriteLocations
        current.append(location)
        Defaults[\.favoriteLocationsKey] = current
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            notificationCenter.post(.init(name: .currentLocation, object: nil, userInfo: ["location": location]))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
}
