//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Devansh Purohit on 3/7/24.
//

import SwiftUI

struct WeatherView: View {
    
    var weather: ResponseBody
    
    let weatherIconsDictionary: [String: String] = [
            "Sunny": "sun.max",
            "Partly cloudy": "cloud.sun",
            "Cloudy": "cloud",
            "Overcast": "smoke",
            "Mist": "cloud.fog",
            "Patchy rain possible": "cloud.drizzle",
            "Patchy snow possible": "cloud.snow",
            "Patchy sleet possible": "cloud.sleet",
            "Patchy freezing drizzle possible": "cloud.hail",
            "Thundery outbreaks possible": "cloud.bolt",
            "Blowing snow": "wind.snow",
            "Blizzard": "snow",
            "Fog": "fog",
            "Freezing fog": "fog.fill",
            "Patchy light drizzle": "cloud.drizzle",
            "Light drizzle": "cloud.drizzle.fill",
            "Freezing drizzle": "cloud.hail",
            "Heavy freezing drizzle": "cloud.hail.fill",
            "Patchy light rain": "cloud.rain",
            "Light rain": "cloud.rain.fill",
            "Moderate rain at times": "cloud.rain",
            "Moderate rain": "cloud.heavyrain",
            "Heavy rain at times": "cloud.heavyrain.fill",
            "Heavy rain": "cloud.heavyrain",
            "Light freezing rain": "cloud.sleet",
            "Moderate or heavy freezing rain": "cloud.sleet.fill",
            "Light sleet": "cloud.sleet",
            "Moderate or heavy sleet": "cloud.sleet.fill",
            "Patchy light snow": "cloud.snow",
            "Light snow": "cloud.snow.fill",
            "Patchy moderate snow": "cloud.snow",
            "Moderate snow": "snow",
            "Patchy heavy snow": "snow.fill",
            "Heavy snow": "snow",
            "Ice pellets": "hail",
            "Light rain shower": "cloud.rain",
            "Moderate or heavy rain shower": "cloud.heavyrain",
            "Torrential rain shower": "cloud.heavyrain.fill",
            "Light sleet showers": "cloud.sleet",
            "Moderate or heavy sleet showers": "cloud.sleet.fill",
            "Light snow showers": "cloud.snow",
            "Moderate or heavy snow showers": "cloud.snow.fill",
            "Light showers of ice pellets": "cloud.hail",
            "Moderate or heavy showers of ice pellets": "cloud.hail.fill",
            "Patchy light rain with thunder": "cloud.sun.bolt",
            "Moderate or heavy rain with thunder": "cloud.bolt.rain",
            "Patchy light snow with thunder": "cloud.bolt.rain.fill",
            "Moderate or heavy snow with thunder": "cloud.bolt.rain.fill",
            "Clear": "moon.stars"
        ]
    
    var body: some View {
        ZStack (alignment: .leading ) {
            VStack {
                VStack(alignment: .leading, spacing: 5){
                    Text(weather.location.name).bold().font(.title)
                    
                    Text("Today,\(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        
                        VStack(spacing:20) {
                            Image(systemName: iconName(forWeatherCondition: weather.current.condition.text))
                                .font(.system(size: 40))
                            
                            Text(weather.current.condition.text)
                        }
                        
                        Spacer()
                        
                        Text(weather.current.temp_c.roundDouble()+"°")
                            .font(.system(size: 100))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding()
                    }
                    
                    Spacer().frame(height:80)
                    
                    AsyncImage(url: URL(string:"https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) {image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:350)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            VStack {
                
                Spacer()
                
                VStack(alignment: .leading, spacing:20) {
                    Text("Weather Now")
                        .bold().padding(.bottom)
                    
                    HStack {
                        WeatherRow(logo: "thermometer", name: "Feels Like (°C)", value: String(weather.current.feelslike_c))
                        Spacer()
                        WeatherRow(logo: "wind", name: "Wind Speed (kph)", value: String(weather.current.wind_kph))
                    }
                    
                    HStack {
                        WeatherRow(logo: "smoke", name: "AQI", value: String(weather.current.air_quality?.us_epa_index ?? 0))
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity              ", value: String(weather.current.humidity))
                    }
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding()
                .padding(.bottom,20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners:[ .topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.68, saturation: 1.0, brightness: 0.567))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
    
    
    func loadWeatherIconsDictionary() -> [String: String] {
        var weatherIconsDictionary: [String: String] = [:]

        // Attempt to locate the CSV file in the app bundle
        if let filepath = Bundle.main.path(forResource: "weather_conditions_to_icons", ofType: "csv") {
            do {
                // Read the contents of the file
                let contents = try String(contentsOfFile: filepath)
                // Break the file into lines
                let lines = contents.components(separatedBy: .newlines)
                
                // Iterate over each line
                for line in lines {
                    // Break each line into components based on the comma
                    let components = line.components(separatedBy: ",")
                    if components.count == 2 {
                        // Assign the first component as the key and the second as the value
                        let condition = components[0]
                        let icon = components[1]
                        weatherIconsDictionary[condition] = icon
                    }
                }
            } catch {
                // Handle errors (file not found, etc.)
                print("Error loading or parsing CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found in app bundle.")
        }

        return weatherIconsDictionary
    }
    
    func iconName(forWeatherCondition condition: String) -> String {
        let dictionary = loadWeatherIconsDictionary()
        return self.weatherIconsDictionary[condition] ?? "sun.max" // Default icon
    }
    
    
    
}

#Preview {
    WeatherView(weather: previewWeather)
}
