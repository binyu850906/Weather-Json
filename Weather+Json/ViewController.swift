//
//  ViewController.swift
//  Weather+Json
//
//  Created by binyu on 2021/7/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!

    let weatherService = WeatherService()

    private let iconMap = [
        "Drizzle" : "cloud.drizzle.fill",
        "Thunderstorm" : "cloud.bolt.rain.fill",
        "Rain" : "cloud.heavyrain.fill",
        "Snow" : "cloud.snow.fill",
        "Clear" : "sun.max.fill",
        "Clouds" : "smoke.fill",

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityNameLabel.text = weather.city
                self.temperatureLabel.text = "\(weather.temperature)"
                self.weatherDescriptionLabel.text = weather.description.capitalized
                self.weatherIcon.image = UIImage(systemName: self.iconMap[weather.iconName]!)
            }
        }
        
    }


}

