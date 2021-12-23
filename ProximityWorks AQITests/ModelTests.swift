//
//  ModelTests.swift
//  ProximityWorks AQITests
//
//  Created by Gaurav Yadav on 23/12/21.
//

import XCTest
@testable import ProximityWorks_AQI

class ModelTests: XCTestCase {

    func test_LatestUpdate() {
        let now = Date.now
        let cityHistory = CityAQIHistory("", aqiHistory: [
            AQI(value: 1.23, timestamp: now),
            AQI(value: 2.3, timestamp: now.addingTimeInterval(5))
        ])
        
        XCTAssertEqual(2.3, cityHistory.latestUpdate.latestValue, "Latest value should have been '2.3'")
    }
    
    func test_BandChangeShouldTrue() {
        let now = Date.now
        let cityHistory = CityAQIHistory("", aqiHistory: [
            AQI(value: 50, timestamp: now),
            AQI(value: 51, timestamp: now.addingTimeInterval(5))
        ])
        
        XCTAssertTrue(cityHistory.latestUpdate.didBandChange, "Band change should have been true")
    }
    
    func test_BandChangeShouldFalse() {
        let now = Date.now
        let cityHistory = CityAQIHistory("", aqiHistory: [
            AQI(value: 50, timestamp: now),
            AQI(value: 49, timestamp: now.addingTimeInterval(5))
        ])
        
        XCTAssertFalse(cityHistory.latestUpdate.didBandChange, "Band change should have been false")
    }

    func test_BandChangeWithoutPreviousValue_ShouldBeFalse() {
        let aqiUpdate = AQIUpdate("", AQI(value: 50, timestamp: Date.now), previous: nil)
        
        XCTAssertFalse(aqiUpdate.didBandChange, "Band change should have bee false") 
    }
}
