//
//  MapViewController.swift
//  LocationNotificationSample
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    private let model: MapModelType = MapModel(locationManager: CLLocationManager(), notificationCenter: NotificationCenter.default)
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

