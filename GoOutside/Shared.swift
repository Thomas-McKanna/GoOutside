//
//  Shared.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/27/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

// constants
let urlSession: SharedURLSession! = SharedURLSession()
let dateFormatter = DateFormatter()
let urlBase = "https://api.darksky.net"
let WEATHER_CELL_ID = "weatherCell"

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
