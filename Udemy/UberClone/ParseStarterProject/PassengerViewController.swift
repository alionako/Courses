//
//  PassengerViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 25/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import MapKit
import Parse

internal class PassengerViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var requestAccepted = false

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callUberButton: UIButton!
    @IBOutlet weak var driverLabel: UILabel!

    // MARK: - Location issues
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()

        callUberButton.isHidden = true
        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.fromKey, equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let requests = objects, !requests.isEmpty {
                self?.callUberButton.setTitle(Constants.cancelRequestTitle, for: [])
            }
            self?.callUberButton.isHidden = false
        }
    }

    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            return
        }
        currentLocation = location
        setRegion(for: 0.01, longDelta: 0.01)
        setAnnotation(for: location, text: "You are here")

        // Update user request location
        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.fromKey, equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let requests = objects {
                requests.forEach {
                    $0[Constants.locationKey] = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
                    $0.saveInBackground()
                    if let driver = $0[Constants.driverKey] as? String, driver != "" {
                        // Get driver location
                        let driverLocationQuery = PFQuery(className: Constants.driverLocationClassnameKey)
                        driverLocationQuery.whereKey(Constants.driverKey, equalTo: driver)
                        driverLocationQuery.findObjectsInBackground { (objects, err) in
                            if let location = objects?.first?[Constants.locationKey] as? PFGeoPoint {
                                self?.setDriverLocation(with: location)
                            }
                        }
                    }
                }
            }
        }
    }

    private func setAnnotation(for coordinate: CLLocationCoordinate2D?, text: String) {
        guard let location = coordinate else {
            return
        }
        // Set annotation
        var hasAnnotation = false
        map.annotations.forEach {
            if $0.coordinate.latitude == location.latitude
                && $0.coordinate.longitude == location.longitude {
                hasAnnotation = true
            } else if let title = $0.title, title == text {
                map.removeAnnotation($0)
            }
        }
        if !hasAnnotation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = text
            map.addAnnotation(annotation)
        }
    }

    private func setRegion(for latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) {
        guard let userLocation = currentLocation, !requestAccepted else {
            return
        }
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta))
        map.setRegion(region, animated: false)
    }

    private func setDriverLocation(with geoPoint: PFGeoPoint) {
        guard let coordinate = currentLocation else {
            return
        }
        let pfCoordinate = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = (geoPoint.distanceInKilometers(to: pfCoordinate) * 100).rounded() / 100
        driverLabel.text = "Driver is \(distance) km away"
        driverLabel.isHidden = false

        guard !requestAccepted else {
            return
        }
        let latDelta = abs(geoPoint.latitude - pfCoordinate.latitude) * 2 + 0.05
        let longDelta = abs(geoPoint.longitude - pfCoordinate.longitude) * 2 + 0.05
        setRegion(for: latDelta, longDelta: longDelta)
        setAnnotation(for: CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude), text: "Driver is here")
        requestAccepted = true
    }

    @IBAction func callUber(_ sender: UIButton) {

        if sender.title(for: .normal) == Constants.callUberTitle {
            callUberRequest()
        } else {
            cancelRequest()
        }
    }

    private func callUberRequest() {
        guard let coordinate = currentLocation else {
            return
        }
        callUberButton.isEnabled = false
        let request = PFObject(className: Constants.requestClassnameKey)
        request[Constants.usernameKey] = PFUser.current()?.username
        request[Constants.fromKey] = PFUser.current()?.objectId
        request[Constants.driverKey] = ""
        request[Constants.locationKey] = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        request.saveInBackground { [weak self] (success, err) in
            self?.callUberButton.isEnabled = true
            if success {
                print("Successful request")
                self?.callUberButton.setTitle(Constants.cancelRequestTitle, for: [])
            } else if let _ = err {
                self?.showAlert(with: "Error", text: "Something went wrong")
            }
        }
    }

    private func cancelRequest() {
        callUberButton.isEnabled = false

        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.fromKey, equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let requests = objects {
                requests.forEach { $0.deleteInBackground() }
            }
            self?.callUberButton.isEnabled = true
            self?.callUberButton.setTitle(Constants.callUberTitle, for: [])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        locationManager.startUpdatingLocation()
    }
}
