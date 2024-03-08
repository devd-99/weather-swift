//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Devansh Purohit on 3/7/24.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        
        guard let url = URL(string:"http://api.weatherapi.com/v1/current.json?key=477b5ccb282a4814a57133705240703&q=\(latitude),\(longitude)&aqi=yes") else {fatalError("missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let(data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from:data)
        
        return decodedData;
        
    }
    
}

struct ResponseBody: Decodable {
    let location: Location
    let current: Current
    
    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime_epoch: Int
        let localtime: String
    }

    struct Current: Decodable {
        let last_updated_epoch: Int
        let last_updated: String
        let temp_c: Double
        let temp_f: Double
        let is_day: Int
        let condition: Condition
        let wind_mph: Double
        let wind_kph: Double
        let wind_degree: Int
        let wind_dir: String
        let pressure_mb: Double
        let pressure_in: Double
        let precip_mm: Double
        let precip_in: Double
        let humidity: Int
        let cloud: Int
        let feelslike_c: Double
        let feelslike_f: Double
        let vis_km: Double
        let vis_miles: Double
        let uv: Double
        let gust_mph: Double
        let gust_kph: Double
        let air_quality: AirQuality?
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
        let code: Int
    }

    struct AirQuality: Decodable {
        let co: Double?
        let no2: Double?
        let o3: Double?
        let so2: Double?
        let pm2_5: Double?
        let pm10: Double?
        let us_epa_index: Int?
        let gb_defra_index: Int?
    }
}



