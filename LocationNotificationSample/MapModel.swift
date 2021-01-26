//
//  MapModel.swift
//  LocationNotificationSample
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import Foundation
import UserNotifications
import CoreLocation
import SwiftyUserDefaults

protocol MapModelType {
    var currentLocation: CLLocation? { get }
    var favoriteLocations: [Location] { get }
    func addFavoriteLocation(_ location: Location)
    func registerNotification(at location: Location)
    func resignNotification(at location: Location)
}

class MapModel: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MapModelType {
    private let locationManager: CLLocationManager
    private let notificationCenter: NotificationCenter
    
    var currentLocation: CLLocation?
    var favoriteLocations: [Location] = []
    var favoriteLocationsObservation: DefaultsDisposable?
    
    var shouldRequestNotificationAuthorization: Bool = false
    
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
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.shouldRequestNotificationAuthorization = true
            }
        }
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
    
    func registerNotification(at location: Location) {
        if shouldRequestNotificationAuthorization {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if let error = error {
                    assert(false, error.localizedDescription)
                    return
                }
                self.shouldRequestNotificationAuthorization = !granted
                
                if granted {
                    self.performNotificationAddition(at: location)
                }
            }
        } else {
            performNotificationAddition(at: location)
        }
    }
    
    func resignNotification(at location: Location) {
        let identifier = location.identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    private func performNotificationAddition(at location: Location) {
        let identifier: String = location.identifier
        let contnet = UNMutableNotificationContent()
        contnet.title = "\(location.place)の近くいます"
        contnet.sound = .default
        let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), radius: 50, identifier: identifier)
        let trigger = UNLocationNotificationTrigger(region: circularRegion, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: contnet, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                assert(false, error.localizedDescription)
            }
        }
    }
    
}
