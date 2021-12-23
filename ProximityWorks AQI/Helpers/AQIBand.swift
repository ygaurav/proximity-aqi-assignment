//
//  AQIBand.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 23/12/21.
//

import Foundation
import UIKit

enum AQIBand: Int, Comparable, CustomDebugStringConvertible {
    
    case good = 6, satisfactory = 5, moderate = 4, poor = 3, veryPoor = 2, severe = 1
    
    init(_ value: Float) {
        switch value {
        case 0..<51:
            self = .good
        case 51..<100:
            self = .satisfactory
        case 100..<200:
            self = .moderate
        case 200..<300:
            self = .poor
        case 300..<400:
            self = .veryPoor
        default:
            self = .severe
        }
    }
    
    static func < (lhs: AQIBand, rhs: AQIBand) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var color: UIColor {
        switch self {
        case .good:
           return #colorLiteral(red: 0.4720913172, green: 0.6820913553, blue: 0.4193440676, alpha: 1)
        case .satisfactory:
            return #colorLiteral(red: 0.7240188122, green: 0.8043723702, blue: 0.4664407969, alpha: 1)
        case .moderate:
            return #colorLiteral(red: 0.9970727563, green: 0.9609283805, blue: 0.4449035525, alpha: 1)
        case .poor:
            return #colorLiteral(red: 0.9262000918, green: 0.6834064126, blue: 0.3593261242, alpha: 1)
        case .veryPoor:
            return #colorLiteral(red: 0.881423533, green: 0.3910139799, blue: 0.3079311252, alpha: 1)
        default:
            return #colorLiteral(red: 0.702395916, green: 0.2972102165, blue: 0.2253859341, alpha: 1)
        }
    }
    
    var debugDescription: String {
        switch self {
        case .good:
            return "Good"
        case .satisfactory:
            return "satisfactory"
        case .moderate:
            return "moderate"
        case .poor:
            return "poor"
        case .veryPoor:
            return "very poor"
        case .severe:
            return "severe"
        }
    }
}
