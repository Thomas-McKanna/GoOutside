//
//  Weather.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/27/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

struct DailyWeather {
    enum WeatherType: String {
        case clearDay, clearNight, rain, snow, sleet, wind, fog, cloudy, partlyCloudyDay, partlyCloudyNight, unclear
    }
    
    let time: Date
    let weekday: Int
    let weather: WeatherType
    let precipChance: Double
    let tempMin: Double
    let tempMax: Double
    let apparentTempMin: Double
    let apparentTempMax: Double
    
    init?(json: [String : Any]) throws {
        // extract time
        guard let time = json["time"] as? Double else {
            throw SerializationError.missing("time")
        }
        
        // extract icon (stored in variable weather)
        guard let string = json["icon"] as? String else {
            throw SerializationError.missing("icon")
        }
        guard let weather = WeatherType(rawValue: convertToIconString(from: string)) else {
            throw SerializationError.invalid("icon (weather)", string)
        }
        
        // extract precipitation probability
        guard let precipChance = json["precipProbability"] as? Double else {
            throw SerializationError.missing("precipitation probability")
        }
        
        // extract minimum temparature
        guard let tempMin = json["temperatureMin"] as? Double else {
            throw SerializationError.missing("minimum temperature")
        }
        
        // extract maximum temparature
        guard let tempMax = json["temperatureMax"] as? Double else {
            throw SerializationError.missing("maximum temperature")
        }
        
        // extract apparent minimum temparature
        guard let apparentTempMin = json["apparentTemperatureMin"] as? Double else {
            throw SerializationError.missing("apparent minimum temperature")
        }
        
        // extract minimum temparature
        guard let apparentTempMax = json["apparentTemperatureMax"] as? Double else {
            throw SerializationError.missing("apparent minimum temperature")
        }
        
        // initialize properties
        self.time = Date.init(timeIntervalSince1970: time)
        self.weekday = getDay(FromDate: self.time)!
        self.weather = weather
        self.precipChance = precipChance
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.apparentTempMin = apparentTempMin
        self.apparentTempMax = apparentTempMax
    }
    
    static func getWeather(at coords: (Double, Double), completion: @escaping ([DailyWeather]) -> Void) {
        
        // set up url
        let coords = String(format: "%f,%f", coords.0, coords.1)
        let path = "/forecast/b6d6ad415a6e8a0d8c0fed979bbd6cac/" + coords
        let queryKey = "exclude"
        let queryValue = "currently,minutely,hourly,alerts,flags"
        
        let url: URL! = getURLWith(Path: path, Query: [URLQueryItem(name: queryKey, value: queryValue)])
        
        print("Requesting data: coord(\(coords))")
        // get data from web server and parse
        urlSession.session.dataTask(with: url) {(data, response, error) in
            var weather: [DailyWeather] = []
            
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                print("Data has arrived: \(data)")
                if let outerJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                    let innerJSON = outerJSON["daily"] as! [String : Any]
                    for case let day in innerJSON["data"] as! [[String : Any]] {
                        if let dailyWeather = try? DailyWeather(json: day) {
                            weather.append(dailyWeather!)
                        }
                    }
                }
            }
            
            start = DispatchTime.now()
            
            print("Data has been parsed...")
            completion(weather)
        }.resume()
    }
}






