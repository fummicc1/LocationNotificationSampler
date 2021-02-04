//
//  MockNotificationCenter.swift
//  LocationNotificationSampleTests
//
//  Created by Fumiya Tanaka on 2021/02/05.
//

import Foundation
import UserNotifications

// TODO: Make Protocol
class MockNotificationCenter: UNUserNotificationCenter {
    
    // TODO: Test deliveredRequests
    var pendingRequests: [UNNotificationRequest] = []
    
    override func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)? = nil) {
        pendingRequests.append(request)
        super.add(request, withCompletionHandler: completionHandler)
        completionHandler?(nil)
    }
    
    override func removeAllPendingNotificationRequests() {
        pendingRequests = []
        super.removeAllPendingNotificationRequests()
    }
    
    override func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        pendingRequests.removeAll(where: { identifiers.contains($0.identifier) })
        super.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

extension MockNotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let request = response.notification.request
        if let index = pendingRequests.firstIndex(where: { $0.identifier == request.identifier }) {
            pendingRequests.remove(at: index)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let request = notification.request
        if let index = pendingRequests.firstIndex(where: { $0.identifier == request.identifier }) {
            pendingRequests.remove(at: index)
        }
        completionHandler([.banner, .list, .sound, .badge])
    }
}
