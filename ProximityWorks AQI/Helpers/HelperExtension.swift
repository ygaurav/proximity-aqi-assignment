//
//  Constants.swift
//  Proximity AQI
//
//  Created by Gaurav Yadav on 18/12/21.
//

import Foundation
import SwiftUI


extension URL {
    static let aqiURL = URL(string: "ws://city-ws.herokuapp.com")!
}

extension UINib {
    static let aqiListCell = UINib(nibName: "CityAQIListCell", bundle: .main)
}

extension Date {
    var customRelativeDateFormat: String {
        let relativity = -timeIntervalSinceNow
        
        switch relativity {
        case 0..<5:
            return "Just now"
        case 5..<10:
            return "A few seconds ago"
        case 10..<30:
            return "Less than a minute ago"
        case 30..<60:
            return "Almost a minute ago"
        case 60..<120:
            return "A min ago"
        case 120..<600:
            return "Few mins ago"
        default:
            return "A while ago"
        }
    }
}
