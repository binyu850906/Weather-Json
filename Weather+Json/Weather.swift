//
//  Weather.swift
//  Weather+Json
//
//  Created by binyu on 2021/7/28.
//

import Foundation

public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        self.city = response.name
        self.temperature = "\(Int(response.main.temp))"
        self.description = response.weather.first?.description ?? ""
        self.iconName = response.weather.first?.iconName ?? ""
    }
}
