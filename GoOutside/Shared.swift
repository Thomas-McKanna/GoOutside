//
//  Shared.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/27/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

let urlSession: SharedURLSession! = SharedURLSession()
let urlBase = "https://api.darksky.net"

func getURLWith(Path p: String, Query q: [URLQueryItem]) -> URL! {
    var urlComponents = URLComponents(string: urlBase)!
    urlComponents.path = p
    urlComponents.queryItems = q
    return urlComponents.url!
}
