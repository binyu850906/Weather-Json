//
//  WeatherService.swift
//  Weather+Json
//
//  Created by binyu on 2021/7/28.
//
import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "2af9058264505462062c113b40605f40"
    
    private var completion: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData (_ completionHandler: @escaping ((Weather) -> Void)) {
        self.completion = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return  }
        
        guard let url = URL(string: urlString) else { return  }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                print("Done")
                self.completion?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return  }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}


struct APIResponse: Codable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Codable {
    let temp: Double
    
}
struct APIWeather: Codable {
    let description: String
    let iconName: String
    
    enum CodingKeys:  String, CodingKey {
        case description
        case iconName = "main"
    }
}
