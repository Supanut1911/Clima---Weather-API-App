//
//  WeatherData.swift
//  Clima
//
//  Created by Supanut Laddayam on 4/4/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation



//weather[0].description
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
