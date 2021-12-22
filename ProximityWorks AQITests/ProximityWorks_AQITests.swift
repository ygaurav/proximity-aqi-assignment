//
//  ProximityWorks_AQITests.swift
//  ProximityWorks AQITests
//
//  Created by Gaurav Yadav on 21/12/21.
//

import XCTest
@testable import ProximityWorks_AQI

class Proximity_AQITests: XCTestCase {

    var mockAQIService: MockAQIService!
    var mockAQIListRouter: MockAQIListRouter!

    override func setUp() {
        mockAQIService = MockAQIService()
        mockAQIListRouter = MockAQIListRouter()
    }

    func test_AQIListViewModel_ResumeCalledAfter() {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)

        XCTAssertFalse(mockAQIService.resumeCalled, "ViewModel should not start receiving updates without calling 'startReceivingUpdates'")

        aqiViewModel.onLoad()

        XCTAssert(mockAQIService.resumeCalled, "Resume should have been called after 'startReceivingUpdates'")
    }

    func test_AQIListViewModel_CorrectlyParseAQIValues() {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockValidMessage))

        XCTAssertEqual(1, aqiViewModel.cityAQIHistories.count, "Should have had 1 city's AQI history")
        XCTAssertEqual(1, aqiViewModel.cityAQIHistories.first(where: { $0.cityName == "Wakanda" })?.aqiHistory.count, "Should have correctly parsed city name")
        XCTAssertEqual(30.0309, aqiViewModel.cityAQIHistories.first(where: { $0.cityName == "Wakanda" })?.aqiHistory.first?.value, "Should have corrrectly parsed AQI value")
    }

    func test_AQIListViewModel_ShouldAddTimeStampToAQI() throws {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockValidMessage))
        let date = Date.now
        let aqi = try XCTUnwrap(aqiViewModel.cityAQIHistories.first(where: { $0.cityName == "Wakanda" })?.aqiHistory.first)

        XCTAssertEqual(date.timeIntervalSince1970.rounded(), aqi.timestamp.timeIntervalSince1970.rounded() , "Current datetime should have been assigned to aqi")
    }

    func test_AQIListViewModel_FailToParseAQIValues() {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)

        aqiViewModel.onLoad()

        mockAQIService.completionHandler?(.success(.mockInValidMessage))

        XCTAssertEqual(0, aqiViewModel.cityAQIHistories.count, "Invalid JSON should not have been parsed.")
    }
    
    func test_AQIListViewModel_CallRouterOnSelect() {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)
        aqiViewModel.cityAQIHistories = [.init("test-city", aqiHistory: [])]
        
        aqiViewModel.onSelect(AQIUpdate(AQI(city: "test-city", value: 10.1, timestamp: Date.now)))

        XCTAssertEqual("test-city", mockAQIListRouter.cityAQIHistory?.cityName, "ViewModel should have passed selected city history to Router")
    }
    
    func test_AQIListViewModel_EmptyHistory_ShouldntCallRouterOnSelect() {
        let aqiViewModel = AQIListViewController.ViewModel(router: mockAQIListRouter, mockAQIService)
        
        aqiViewModel.onSelect(AQIUpdate(AQI(city: "test-city", value: 10.1, timestamp: Date.now)))

        XCTAssertNil(mockAQIListRouter.cityAQIHistory, "ViewModel should not have passed selected city history if its not in viewModel")
    }
}

extension URLSessionWebSocketTask.Message {
    static let mockValidMessage: URLSessionWebSocketTask.Message  = .string("[{ \"city\": \"Wakanda\", \"aqi\": 30.0309 }]")
    static let mockInValidMessage: URLSessionWebSocketTask.Message  = .string("[{ \"cit\": \"Wakanda\", \"aqi\": 30.0309 }]")
}

class MockAQIService: AQIService {
    
    var resumeCalled = false
    
    var completionHandler: ((Result<URLSessionWebSocketTask.Message, Error>) -> Void)?
    
    func resume() {
        resumeCalled = true
    }
    
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        self.completionHandler = completionHandler
    }
    
}

class MockAQIListRouter: AQIListRouter {
    
    var cityAQIHistory: CityAQIHistory?
    
    func showGraph(for history: CityAQIHistory) {
        cityAQIHistory = history
    }
}
