//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Aliona on 21/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var numberOfPlace : Int?
    var manager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if numberOfPlace == nil {
            let gestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(MapViewController.tap(_:)))
            gestureRecognizer.minimumPressDuration = 2.0
            map.addGestureRecognizer(gestureRecognizer)
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            if let lat = manager.location?.coordinate.latitude,
                let long = manager.location?.coordinate.longitude {
                
                showCoordinateWithParams(["lat" : String(lat), "long": String(long), "name": ""], annotated: false)
            }
            
        } else {
            if let index = numberOfPlace {
                let currentCoordinate = places[index]
                self.title = currentCoordinate["name"]
                showCoordinateWithParams(currentCoordinate, annotated: true)
            }
        }
    }
    
    func showCoordinateWithParams(_ params: Dictionary<String, String>, annotated: Bool) {
        if  let lat = params["lat"],
            let long = params["long"] {
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.map.setRegion(region, animated: true)
            
            if annotated {
                let annotation = MKPointAnnotation()
                if let name = params["name"] {
                    annotation.title = name
                }
                annotation.coordinate = coordinate
                self.map.addAnnotation(annotation)
            }
        }
    }
    
    func tap(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
        
            let location = gesture.location(in: map)
            let coordinate = self.map.convert(location, toCoordinateFrom: self.map)
            let clCoordinate = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(clCoordinate, completionHandler: { (placemarks, err) in
                if let error = err {
                    print(error)
                } else {
                    if let placemark = placemarks?[0] {
                        if let subTh = placemark.subThoroughfare {
                            title += subTh + " "
                        }
                        if let th = placemark.thoroughfare {
                            title += th
                        }
                        if title == "" {
                            title = "Added \(Date())"
                        }
                    }
                    
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                
                let dictionary = ["name" : title,
                                  "lat" : String(coordinate.latitude),
                                  "long" : String(coordinate.longitude)]
                places.append(dictionary)
                UserDefaults.standard.set(places, forKey: "places")
            })
        }
        
    }
    
}
