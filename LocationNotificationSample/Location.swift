//
//  Location.swift
//  LocationNotificationSample
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteLocationsKey: DefaultsKey<[Location]> {
        .init("favoriteLocations", defaultValue: [])
    }
}

struct Location: Codable, DefaultsSerializable {
    var latitude: Double
    var longitude: Double
    var place: String
}
