//
//  Errors.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/28/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

//  serialization error cases
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
