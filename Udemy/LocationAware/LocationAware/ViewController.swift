//
//  ViewController.swift
//  LocationAware
//
//  Created by Aliona on 21/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var alt: UILabel!
    @IBOutlet weak var address: UILabel!

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        lat.text = String(location.coordinate.latitude)
        long.text = String(location.coordinate.longitude)
        course.text = String(location.course)
        speed.text = String(location.speed)
        alt.text = String(location.altitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            if let error = err?.localizedDescription {
                self.address.text = error
            } else {
                if let placemark = placemarks?[0] {
                    
                    var address = ""
                    
                    if let subTh = placemark.subThoroughfare {
                        address += subTh + " "
                    }
                    
                    if let th = placemark.thoroughfare {
                        address += th + "\n"
                    }
                    
                    if let locality = placemark.subLocality {
                        address += locality + "\n"
                    }
                    
                    if let area = placemark.subAdministrativeArea {
                        address += area + "\n"
                    }
                    
                    if let code = placemark.postalCode {
                        address += code + "\n"
                    }
                    
                    if let country = placemark.country {
                        address += country + "\n"
                    }
                    
                    self.address.text = address
                }
            }
        }
        
    }

}

