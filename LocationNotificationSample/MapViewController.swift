//
//  MapViewController.swift
//  LocationNotificationSample
//
//  Created by Fumiya Tanaka on 2021/01/25.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    private let notificationCenter: NotificationCenter = .default
    
    private lazy var model: MapModelType = MapModel(locationManager: CLLocationManager(), notificationCenter: notificationCenter)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeModeButton: UIButton!
    
    let addImage: UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
       let image = UIImage(systemName: "plus", withConfiguration: config)
        return image!
    }()
    
    let xMarkImage: UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
       let image = UIImage(systemName: "xmark", withConfiguration: config)
        return image!
    }()
    
    var isSelectingCoordinate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        changeModeButton.layer.cornerRadius = 16
        changeModeButton.layer.cornerCurve = .continuous
        notificationCenter.addObserver(self, selector: #selector(didUpdateFavoriteLocations), name: .favoriteLocations, object: nil)
        mapView.delegate = self
        mapView.showsUserLocation = true
        updateAnnotations()        
    }

    @objc
    private func didUpdateFavoriteLocations() {
        updateAnnotations()
    }
    
    private func updateAnnotations() {
        let locations = model.favoriteLocations
        let annotations: [MKAnnotation] = locations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    @IBAction func changeMapMode() {
        isSelectingCoordinate.toggle()
        if isSelectingCoordinate {
            changeModeButton.setImage(xMarkImage, for: .normal)
        } else {
            changeModeButton.setImage(addImage, for: .normal)
        }
    }
    
    @IBAction func tapMapView(_ tapGesture: UITapGestureRecognizer) {
        if isSelectingCoordinate == false {
            return
        }
        let viewLocation = tapGesture.location(in: mapView)
        let coordinate = mapView.convert(viewLocation, toCoordinateFrom: mapView)
        let alert = UIAlertController(title: "お気に入りの追加", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "完了", style: .default, handler: { [weak self] _ in
            var location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude, place: "")
            if let textField = alert.textFields?.first {
                location.place = textField.text!
            }
            self?.model.addFavoriteLocation(location)
        }))
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "場所について入力しましょう"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is MKUserLocationView {
            return
        }
        guard let annotation = view.annotation else {
            return
        }
        let coordinate = annotation.coordinate
        guard let location = model.favoriteLocations.first(where: { location -> Bool in
            location.latitude == coordinate.latitude && location.longitude == coordinate.longitude
        }) else {
            return
        }
        let sheet = UIAlertController(title: "\(location.place)", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "通知を有効にする", style: .default, handler: { [weak self] _ in
            fatalError()
        }))
        sheet.addAction(UIAlertAction(title: "通知を無効にする", style: .default, handler: { [weak self] _ in
            fatalError()
        }))
        sheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}

