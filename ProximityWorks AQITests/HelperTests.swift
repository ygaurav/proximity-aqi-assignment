//
//  HelperTests.swift
//  ProximityWorks AQITests
//
//  Created by Gaurav Yadav on 22/12/21.
//

import XCTest
@testable import ProximityWorks_AQI

class HelperTests: XCTestCase {

    func test_AQIBand_Values() {
        XCTAssertEqual(.good, AQIBand(50), "AQI Band should have been 'good'")
        XCTAssertNotEqual(.good, AQIBand(51), "AQI Band should not have been 'good'")
        
        XCTAssertEqual(.satisfactory, AQIBand(51), "AQI Band should have been 'satisfactory'")
        XCTAssertNotEqual(.satisfactory, AQIBand(101), "AQI Band should not have been 'satisfactory'")
        
        XCTAssertEqual(.moderate, AQIBand(101), "AQI Band should have been 'moderate'")
        XCTAssertNotEqual(.moderate, AQIBand(201), "AQI Band should not have been 'moderate'")
        
        XCTAssertEqual(.poor, AQIBand(201), "AQI Band should have been 'poor'")
        XCTAssertNotEqual(.poor, AQIBand(301), "AQI Band should not have been 'poor'")
        
        XCTAssertEqual(.veryPoor, AQIBand(301), "AQI Band should have been 'veryPoor'")
        XCTAssertNotEqual(.veryPoor, AQIBand(401), "AQI Band should not have been 'veryPoor'")
        
        XCTAssertEqual(.severe, AQIBand(401), "AQI Band should have been 'severe'")
        XCTAssertEqual(.severe, AQIBand(501), "AQI Band should not have been 'severe'")
    }

    func test_AQIBand_Comparision() {
        XCTAssert(AQIBand.good > AQIBand.satisfactory, "Good is better than Satisfactory")
        XCTAssert(AQIBand.satisfactory > AQIBand.moderate, "Satisfactory is better than Moderate")
        XCTAssert(AQIBand.moderate > AQIBand.poor, "Moderate is better than Poor")
        XCTAssert(AQIBand.poor > AQIBand.veryPoor, "Poor is better than VeryPoor")
        XCTAssert(AQIBand.veryPoor > AQIBand.severe, "VeryPoor is better than Severe")
    }
}
