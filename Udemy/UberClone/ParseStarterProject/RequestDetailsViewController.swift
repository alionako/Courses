//
//  RequestDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 26/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class RequestDetailsViewController: UIViewController, MKMapViewDelegate {

    var driverLocation: CLLocationCoordinate2D?
    var userLocation: CLLocationCoordinate2D?
    var from: String?
    var username: String?

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var acceptRequestButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnnotations(coordinate: driverLocation, text: "You are here")
        setAnnotations(coordinate: userLocation, text: "Passenger is here")
        setRegion()
        checkState()
    }

    @IBAction func acceptRequest(_ sender: UIButton) {

        let isCancelling = acceptRequestButton.title(for: .normal) == Constants.cancelOrderTitle
        let newTitle = isCancelling ? Constants.acceptRequestTitle : Constants.cancelOrderTitle
        let driverId = isCancelling ? "" : PFUser.current()?.objectId ?? ""
        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.fromKey, equalTo: from ?? "")
        query.limit = 1
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let request = objects?.first {
                if isCancelling {
                    request[Constants.driverKey] = ""
                } else {
                    request[Constants.driverKey] = driverId
                }
                request.saveInBackground(block: { (success, err) in
                    if success {
                        isCancelling ? self?.dismiss(animated: true, completion: nil) : self?.openAppleMaps()
                        self?.acceptRequestButton.setTitle(newTitle, for: [])
                    }
                })
            }
        }
    }

    private func checkState() {
        acceptRequestButton.isEnabled = false
        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.fromKey, equalTo: from ?? "")
        query.limit = 1
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let request = objects?.first {
                if request[Constants.driverKey] as? String != "" {
                    self?.acceptRequestButton.setTitle(Constants.cancelOrderTitle, for: [])
                }
            }
            self?.acceptRequestButton.isEnabled = true
        }
    }

    private func openAppleMaps() {
        guard let location = userLocation else {
            return
        }
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first {
                let mkPlacemark = MKPlacemark(placemark: placemark)
                let mapItem = MKMapItem(placemark: mkPlacemark)
                mapItem.name = self?.username
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options)
            }
        })
    }

    // MARK: - Map settings

    private func setRegion() {
        guard let coordinate = userLocation else {
            return
        }
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: false)
    }

    private func setAnnotations(coordinate: CLLocationCoordinate2D?, text: String) {
        guard let coordinate = coordinate else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = text
        map.addAnnotation(annotation)
    }
}
