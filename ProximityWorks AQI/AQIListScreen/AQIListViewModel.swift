//
//  AQIListViewModel.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import Foundation

protocol AQIListViewModelDelegate: AnyObject {
    func updateSnapshot(with: [AQIUpdate])
}

protocol AQIListViewModel {
    var viewDelegate: AQIListViewModelDelegate? { get set }
    func onLoad()
    func onSelect(_: AQIUpdate)
}

extension AQIListViewController {
    
    class ViewModel: AQIListViewModel {
        
        var cityAQIHistories = [CityAQIHistory]()
        
        private weak var aqiService: AQIService?
        private var router: AQIListRouter
        weak var viewDelegate: AQIListViewModelDelegate?
        
        init(router: AQIListRouter, _ service: AQIService = APIClient.shared.websocketTask(with: .aqiURL)) {
            self.aqiService = service
            self.router = router
        }
        
        func onLoad() {
            startReceivingUpdates()
        }
        
        private func startReceivingUpdates() {
            receiveMessage()
            aqiService?.resume()
        }
        
        func onSelect(_ update: AQIUpdate) {
            guard let cityHistory = cityAQIHistories.first(where: { $0.cityName == update.city }) else { return }
            
            router.showGraph(for: cityHistory)
        }
        
        private func receiveMessage() {
            aqiService?.receive { [weak self] result in
                guard let self = self else { return }
                defer { self.processSnapshot() }
                do {
                    let aqiModels = try result.parseMessage()
                    
                    let now = Date()
                    
                    for aqiModel in aqiModels {
                        if let index = self.cityAQIHistories.firstIndex(where: { $0.cityName == aqiModel.city }) {
                            var cityAQIHistory = self.cityAQIHistories.remove(at: index)
                            cityAQIHistory.add(AQI(city: aqiModel.city, value: aqiModel.aqi, timestamp: now))
                            self.cityAQIHistories.append(cityAQIHistory)
                        } else {
                            self.cityAQIHistories.append(CityAQIHistory(aqiModel.city, aqiHistory: [AQI(city: aqiModel.city, value: aqiModel.aqi, timestamp: now)]))
                        }
                    }
                    self.receiveMessage()
                } catch {
                    print("Error fetching data - \(error.localizedDescription)")
                }
            }
        }
        
        private func processSnapshot() {
            viewDelegate?.updateSnapshot(with: cityAQIHistories.sorted { $0.cityName < $1.cityName }.map { $0.latestUpdate })
        }
        
    }
    
}

protocol AQIService: AnyObject {
    func resume()
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void)
}

extension URLSessionWebSocketTask: AQIService { }
