//
//  CityAQIGraphViewModelTests.swift
//  ProximityWorks AQITests
//
//  Created by Gaurav Yadav on 24/12/21.
//

import XCTest
@testable import ProximityWorks_AQI

class CityAQIGraphViewModelTests: XCTestCase {

    var mockAQIService: MockAQIService!

    override func setUp() {
        mockAQIService = MockAQIService()
    }

    func test_AQIGraphViewModel_ResumeCalledAfter() {
        let aqiViewModel = CityAQIGraphViewController.ViewModel(aqiHistory: .dummy, mockAQIService)

        XCTAssertFalse(mockAQIService.resumeCalled, "ViewModel should not start receiving updates without calling 'startReceivingUpdates'")

        aqiViewModel.onLoad()

        XCTAssert(mockAQIService.resumeCalled, "Resume should have been called after 'startReceivingUpdates'")
    }

    func test_AQIGraphViewModel_CorrectlyParseAQIValues() {
        let aqiViewModel = CityAQIGraphViewController.ViewModel(aqiHistory: .wakanda, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockValidMessage))

        XCTAssertEqual(2, aqiViewModel.cityAqiHistory.aqiHistory.count, "Count should have increased to 2")
        XCTAssertEqual(30.0309, aqiViewModel.cityAqiHistory.aqiHistory.last?.value, "Should have corrrectly parsed AQI value")
    }
    
    func test_AQIGraphViewModel_OtherCityValues_ShouldNotAddToHistory() {
        let aqiViewModel = CityAQIGraphViewController.ViewModel(aqiHistory: .wakanda, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockOtherCityValidMessage))

        XCTAssertEqual(1, aqiViewModel.cityAqiHistory.aqiHistory.count, "Count should stay 1")
        XCTAssertEqual(12.34, aqiViewModel.cityAqiHistory.aqiHistory.last?.value, "Latest AQI values should have remained same")
    }

    func test_AQIGraphViewModel_ShouldAddTimeStampToAQI() throws {
        let aqiViewModel = CityAQIGraphViewController.ViewModel(aqiHistory: .wakanda, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockValidMessage))
        let date = Date.now
        let aqi = try XCTUnwrap(aqiViewModel.cityAqiHistory.aqiHistory.first)

        XCTAssertEqual(date.timeIntervalSince1970.rounded(), aqi.timestamp.timeIntervalSince1970.rounded() , "Current datetime should have been assigned to aqi")
    }

    func test_AQIGraphViewModel_FailToParseAQIValues() {
        let aqiViewModel = CityAQIGraphViewController.ViewModel(aqiHistory: .wakanda, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockInValidMessage))

        XCTAssertEqual(1, aqiViewModel.cityAqiHistory.aqiHistory.count, "Invalid JSON should not have been parsed.")
    }

}

private extension URLSessionWebSocketTask.Message {
    static let mockValidMessage: URLSessionWebSocketTask.Message  = .string("[{ \"city\": \"Wakanda\", \"aqi\": 30.0309 }]")
    static let mockValidMessage_MultipleValues: URLSessionWebSocketTask.Message  = .string("[{ \"city\": \"Wakanda\", \"aqi\": 30.0309 }, {\"city\":\"Wakanda\", \"aqi\": 31}]")
    static let mockInValidMessage: URLSessionWebSocketTask.Message  = .string("[{ \"cit\": \"Wakanda\", \"aqi\": 30.0309 }]")
    static let mockOtherCityValidMessage: URLSessionWebSocketTask.Message  = .string("[{ \"city\": \"Latveria\", \"aqi\": 30.0309 }]")
}

private extension CityAQIHistory {
    static let dummy = CityAQIHistory("dummy", aqiHistory: [])
    static let wakanda = CityAQIHistory("Wakanda", aqiHistory: [AQI(value: 12.34, timestamp: .now)])
}
