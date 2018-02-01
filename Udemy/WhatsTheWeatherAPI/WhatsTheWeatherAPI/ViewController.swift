//
//  ViewController.swift
//  WhatsTheWeatherAPI
//
//  Created by Aliona on 28/08/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func checkWeather(_ sender: Any) {
        
        guard let text = city.text?.replacingOccurrences(of: " ", with: "") else {
            label.text = "Please check the city field!"
            return
        }
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + text + "&appid=2dac6d52f6d2419187da6b4eb9e066e7")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil {
                print(err!)
            } else {
                
                if data != nil  {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        if let weather = jsonResult?["weather"] as? [NSDictionary] {
                            if let desc = weather[0]["description"] as? String {
                                print(desc)
                                DispatchQueue.main.sync {
                                    self.label.text = desc
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
        
    }
    

}

