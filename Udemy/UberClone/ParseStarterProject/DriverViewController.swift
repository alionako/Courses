//
//  DriverViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Aliona on 26/01/2018.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class DriverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var data: [PFObject] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
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
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        currentLocation = coordinate
        getRequests(with: coordinate)
        updateDriverLocation(with: coordinate)
    }

    private func updateDriverLocation(with coordinate: CLLocationCoordinate2D) {
        guard let driverID = PFUser.current()?.objectId else {
            return
        }
        let query = PFQuery(className: Constants.driverLocationClassnameKey)
        query.whereKey(Constants.driverKey, equalTo: driverID)
        query.findObjectsInBackground { (objects, err) in
            let location: PFObject
            if let object = objects?.first {
                location = object
            } else {
                location = PFObject(className: Constants.driverLocationClassnameKey)
                location[Constants.driverKey] = driverID
            }
            location[Constants.locationKey] = PFGeoPoint(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            location.saveInBackground()
        }
    }

    private func getRequests(with coordinate: CLLocationCoordinate2D) {
        let query = PFQuery(className: Constants.requestClassnameKey)
        query.whereKey(Constants.locationKey, nearGeoPoint: PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
        query.whereKey(Constants.driverKey, containedIn: [PFUser.current()?.objectId ?? "", ""])
        query.limit = 10
        query.findObjectsInBackground { [weak self] (objects, err) in
            if let requests = objects {
                self?.data = requests
                self?.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let location = data[indexPath.row][Constants.locationKey] as? PFGeoPoint, let current = currentLocation {

            let driverLocation = PFGeoPoint(latitude: current.latitude, longitude: current.longitude)
            let distance = (location.distanceInKilometers(to: driverLocation) * 100).rounded() / 100
            let userText = data[indexPath.row][Constants.usernameKey] as? String ?? ""
            cell.textLabel?.text = userText.isEmpty ? "\(distance) km away" : "\(userText) \(distance) km away"
        }
        cell.selectionStyle = .none
        cell.accessoryType = data[indexPath.row][Constants.driverKey] as? String != "" ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details",
            let index = (sender as? IndexPath)?.row,
            let location = data[index][Constants.locationKey] as? PFGeoPoint,
            let destination = segue.destination as? RequestDetailsViewController {

            destination.from = data[index][Constants.fromKey] as? String
            destination.username = data[index][Constants.usernameKey] as? String
            destination.driverLocation = currentLocation
            destination.userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}
