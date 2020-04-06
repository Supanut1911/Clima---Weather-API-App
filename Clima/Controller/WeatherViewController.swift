//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let loactionManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        loactionManager.delegate = self
        loactionManager.requestWhenInUseAuthorization()
        loactionManager.requestLocation()
    }

    
    
}

//MARK:-UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPress(_ sender: UIButton) {
        
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }

    
    //press return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            
        } else {
            print("fetch error")
        }
    
        searchTextField.text = ""
    }
    
    //validation user type
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK:-WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
}

extension WeatherViewController: CLLocationManagerDelegate{

    @IBAction func currnetButtonPress(_ sender: UIButton) {
        loactionManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            loactionManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
