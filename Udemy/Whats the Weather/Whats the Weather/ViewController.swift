//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Aliona on 28/07/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var forecast: UILabel!
    @IBOutlet weak var city: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.layer.cornerRadius = 4.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkWeather(_ sender: UIButton) {
        self.getForecast(city.text)
    }
    
    private func getForecast(_ city: String?) {
        
        if city == "" {
            setWeatherText("You need to enter the city first!")
        }
        
        let errorText = "Location not found :("
        
        if let city = city?.replacingOccurrences(of: " ", with: "-"),
            let url = URL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if let err = error as? String {
                    self.setWeatherText(err)
                } else {
                    if let _ = data,
                        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        if let parsedWeather = self.parseWeather(dataString) {
                            self.setWeatherText(parsedWeather)
                        }
                    } else {
                        self.setWeatherText(errorText)
                    }
                }
            }
            task.resume()
        } else {
            setWeatherText(errorText)
        }
    }
    
    private func parseWeather(_ html: NSString) -> String? {
        
        let substrings = html.components(separatedBy: "<span class=\"phrase\">")
        if substrings.count > 1 && (substrings[1].characters.index(of: "<") != nil) {
            return substrings[1].substring(to: substrings[1].characters.index(of: "<")!).replacingOccurrences(of: "&deg;C", with: "℃")
        }
        
        return nil
    }
    
    private func setWeatherText(_ string: String) {
        DispatchQueue.main.async {
            self.forecast.text = string
        }
    }
}

