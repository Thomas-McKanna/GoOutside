//
//  Scoring.swift
//  GoOutside
//
//  Created by Thomas McKanna on 2/1/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

private var tempScoringDictionary: [Int: Double] = [:]

func makeTempScoringArray() {
    let idealTemperature = IDEAL_TEMP
    let idealSquared = pow(idealTemperature, 2.0)
    var absDifference: Double = 0
    
    for t in MIN_TEMP...MAX_TEMP {
        absDifference = Double(abs(Int32(idealTemperature - Double(t))))
        tempScoringDictionary[t] = (pow(absDifference + idealTemperature, 2))/idealSquared - 1
    }
    
    for t in Int(idealTemperature + 1)...MAX_TEMP {
        tempScoringDictionary[t] = tempScoringDictionary[t]! + tempScoringDictionary[t - 1]!
    }
    
    // cannot interate backwards using other methods
    for t in stride(from: Int(idealTemperature - 1), to: MIN_TEMP, by: -1) {
        tempScoringDictionary[t] = tempScoringDictionary[t]! + tempScoringDictionary[t + 1]!
    }
    
}

func scoreDay(withTemp temp: Double, andPrecipProbability prob: Double) -> Int {
    return Int(100.0 - (tempScoringDictionary[Int(temp)]! + PRECIP_PENALTY * prob))
}
