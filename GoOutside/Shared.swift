//
//  Shared.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/27/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation
import UIKit.UIColor

// global constants
let urlSession: SharedURLSession! = SharedURLSession()
let dateFormatter = DateFormatter()
let urlBase = "https://api.darksky.net"
let WEATHER_CELL_ID = "weatherCell"
let MAX_TEMP = 125
let MIN_TEMP = -30
let DEGREE_SYMBOL = "\u{00B0}"
let userDefaults = UserDefaults.standard

// global variables
var IDEAL_TEMP = 70.0
var PRECIP_PENALTY = 70.0

// temporary (for performance measure)
var start: DispatchTime?
var end: DispatchTime?

// colors
let colorSky: UIColor = UIColor.init(red: 66.0/255.0, green: 235.0/255.0, blue: 244.0/255.0, alpha: 1.0)
let colorSpring: UIColor = UIColor.init(red: 12.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
let colorDarkGrayReducedOpacity: UIColor = UIColor.init(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 0.80)
let colorCloudy: UIColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/230.0, alpha: 1.0)
let colorIdeal_10: UIColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
let colorIdeal_9: UIColor = UIColor.init(red: 50.0/255.0, green: 255.0/255.0, blue: 50.0/255.0, alpha: 1.0)
let colorIdeal_8: UIColor = UIColor.init(red: 100.0/255.0, green: 255.0/255.0, blue: 100.0/255.0, alpha: 1.0)
let colorIdeal_7: UIColor = UIColor.init(red: 150.0/255.0, green: 255.0/255.0, blue: 150.0/255.0, alpha: 1.0)
let colorIdeal_6: UIColor = UIColor.init(red: 200.0/255.0, green: 255.0/255.0, blue: 200.0/255.0, alpha: 1.0)
let colorIdeal_5: UIColor = UIColor.init(red: 255.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
let colorIdeal_4: UIColor = UIColor.init(red: 255.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
let colorIdeal_3: UIColor = UIColor.init(red: 255.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
let colorIdeal_2: UIColor = UIColor.init(red: 255.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
let colorIdeal_1: UIColor = UIColor.init(red: 180.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
let colorIdeal_0: UIColor = UIColor.init(red: 100.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)

// global functions
func getURLWith(Path p: String, Query q: [URLQueryItem]) -> URL! {
    var urlComponents = URLComponents(string: urlBase)!
    urlComponents.path = p
    urlComponents.queryItems = q
    return urlComponents.url!
}

func convertToIconString(from s: String) -> String {
    switch s {
    case "clear-day": return "clearDay"
    case "clear-night": return "clearNight"
    case "partly-cloudy-day": return "partlyCloudyDay"
    case "partly-cloudy-night": return "partlyCloudyNight"
    default: return s
    }
}

func getDay(FromDate d: Date) -> Int? {
    let calendar = NSCalendar(calendarIdentifier: .gregorian)
    let components = calendar?.components(.weekday, from: d)
    let weekday = components?.weekday
    return weekday
}

func convertToWeekday(Number n: Int) -> String {
    switch n {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Error"
    }
}

func convertToCleanText(Weather w: String) -> String {
    switch w {
        case "clearDay": return "Sunny"
        case "clearNight": return "Sunny"
        case "partlyCloudyDay": return "Partly Cloudy"
        case "partlyCloudyNight": return "Sunny"
        case "cloudy": return "Cloudy"
        case "rain": return "Rain"
        case "snow": return "Snow"
        case "sleet": return "Sleet"
        case "wind": return "Sunny"
        case "fog": return "Fog"
        default: return "Error"
    }
}

func returnColor(ForWeather w: String) -> UIColor {
    switch w {
    case "clearDay": return UIColor.yellow
    case "clearNight": return UIColor.yellow
    case "partlyCloudyDay": return colorCloudy
    case "partlyCloudyNight": return UIColor.yellow
    case "cloudy": return colorCloudy
    case "rain": return UIColor.blue
    case "snow": return UIColor.white
    case "sleet": return UIColor.cyan
    case "wind": return UIColor.yellow
    case "fog": return UIColor.darkGray
    default: return UIColor.black
    }
}

func returnColor(ForScore s: Int) -> UIColor {
    if s == 100 {
        return colorIdeal_10
    }
    if s >= 90 {
        return colorIdeal_9
    }
    if s >= 80 {
        return colorIdeal_8
    }
    if s >= 70 {
        return colorIdeal_7
    }
    if s >= 60 {
        return colorIdeal_6
    }
    if s >= 50 {
        return colorIdeal_5
    }
    if s >= 40 {
        return colorIdeal_4
    }
    if s >= 30 {
        return colorIdeal_3
    }
    if s >= 20 {
        return colorIdeal_2
    }
    if s >= 10 {
        return colorIdeal_1
    }
    if s >= 0 {
        return colorIdeal_0
    }
    return UIColor.black
}
