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
let PRECIP_PENALTY = 70.0

// global variables
var IDEAL_TEMP = 70.0

// temporary (for performance measure)
var start: DispatchTime?
var end: DispatchTime?

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
        case "partlyCloudyDay": return "Cloudy"
        case "partlyCloudyNight": return "Cloudy"
        case "cloudy": return "Cloudy"
        case "rain": return "Rain"
        case "snow": return "Snow"
        case "sleet": return "Sleet"
        case "wind": return "Wind"
        case "fog": return "Fog"
        default: return "Error"
    }
}

func returnColor(ForWeather w: String) -> UIColor {
    switch w {
    case "clearDay": return UIColor.yellow
    case "clearNight": return UIColor.yellow
    case "partlyCloudyDay": return UIColor.lightGray
    case "partlyCloudyNight": return UIColor.lightGray
    case "cloudy": return UIColor.lightGray
    case "rain": return UIColor.blue
    case "snow": return UIColor.white
    case "sleet": return UIColor.cyan
    case "wind": return UIColor.magenta
    case "fog": return UIColor.darkGray
    default: return UIColor.black
    }
}

func returnColor(ForScore s: Int) -> UIColor {
    if s >= 90 {
        return UIColor.black
    }
    if s >= 80 {
        return UIColor.black
    }
    if s >= 70 {
        return UIColor.black
    }
    if s >= 60 {
        return UIColor.black
    }
    if s >= 50 {
        return UIColor.black
    }
    if s >= 40 {
        return UIColor.black
    }
    if s >= 30 {
        return UIColor.black
    }
    if s >= 20 {
        return UIColor.black
    }
    if s >= 10 {
        return UIColor.black
    }
    if s >= 0 {
        return UIColor.black
    }
    return UIColor.black
}
