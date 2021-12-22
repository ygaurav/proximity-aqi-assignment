//
//  Models.swift
//  Proximity AQI
//
//  Created by Gaurav Yadav on 18/12/21.
//

import Foundation
import UIKit

enum AQIListSection {
    case main
}

struct CityAQIHistory: Identifiable, CustomDebugStringConvertible {
    let id = UUID()
    let cityName: String
    var aqiHistory: [AQI]
    
    var latestUpdate: AQIUpdate {
        guard aqiHistory.count >= 1 else {
            fatalError("Cannot create AQI history without even a single entry")
        }
        
        let latestAQI = aqiHistory[aqiHistory.endIndex - 1]

        let previous = aqiHistory.indices.contains(aqiHistory.endIndex - 2) ? aqiHistory[aqiHistory.endIndex - 2] : nil
        
        return AQIUpdate(latestAQI, previous: previous)
    }
    
    init(_ name: String, aqiHistory: [AQI]) {
        self.cityName = name
        self.aqiHistory = aqiHistory
    }
    
    mutating func add(_ aqi: AQI) {
        aqiHistory.append(aqi)
    }
    
    var debugDescription: String {
        "\(cityName) - \(aqiHistory)"
    }
}

struct AQI: Hashable, CustomDebugStringConvertible  {
    let city: String
    let value: Float
    let timestamp: Date
    
    var aqiBandColor: UIColor { aqiBand.color }
    var aqiBand: AQIBand { AQIBand(value) }
    
    init(city: String, value: Float, timestamp: Date) {
        self.city = city
        self.value = value
        self.timestamp = timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(timestamp)
    }
    
    var debugDescription: String {
        "\(city): \(value) - \(timestamp.formatted(.relative(presentation: .numeric)))"
    }
}

struct AQIJsonModel: Decodable {
    let city: String
    let aqi: Float
}

struct AQIUpdate: Hashable {
    private let previousAQI: AQI?
    private let latestAQI: AQI
    
    var latestValue: Float { latestAQI.value }
    var city: String { latestAQI.city }
    var updateTime: Date { latestAQI.timestamp }
    var bandColor: UIColor { latestAQI.aqiBandColor }
    
    var didBandChange: Bool {
        guard let previous = previousAQI else { return false }
        return latestAQI.aqiBand != previous.aqiBand
    }
    
    var aqiBandImproved: Bool {
        guard let previous = previousAQI else { return false }
        return latestAQI.aqiBand > previous.aqiBand
    }
    
    init(_  update: AQI, previous: AQI? = nil) {
        self.latestAQI = update
        self.previousAQI = previous
    }
}
