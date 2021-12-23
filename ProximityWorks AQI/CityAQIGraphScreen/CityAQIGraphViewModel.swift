//
//  CityAQIGraphViewModel.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import Foundation

protocol CityAQIHistoryViewModelDelegate: AnyObject {
    func update(history: [DataPoint])
}

protocol CityAQIGraphViewModel {
    func onLoad()
}

extension CityAQIGraphViewController {
    
    class ViewModel: CityAQIGraphViewModel {
        
        var cityAqiHistory: CityAQIHistory
        
        var timer: Timer?
        private weak var aqiService: AQIService?
        weak var viewDelegate: CityAQIHistoryViewModelDelegate?
        
        init(aqiHistory: CityAQIHistory, _ service: AQIService = APIClient.shared.websocketTask(with: .aqiURL)) {
            self.cityAqiHistory = aqiHistory
            self.aqiService = service
        }
        
        func onLoad() {
            startReceivingUpdates()
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(processAqiHistory), userInfo: nil, repeats: true)
            processAqiHistory()
        }
        
        private func startReceivingUpdates() {
            receiveMessage()
            aqiService?.resume()
        }
        
        private func receiveMessage() {
            aqiService?.receive { [weak self] result in
                guard let self = self else { return }
                defer { self.receiveMessage() }
                do {
                    let aqiModels = try result.parseMessage()
                    
                    if let aqi = aqiModels.first(where: { $0.city == self.cityAqiHistory.cityName })?.aqi {
                        self.cityAqiHistory.add(AQI(value: aqi, timestamp: Date()))
                    }
                } catch {
                    print("Error fetching data - \(error.localizedDescription)")
                }
            }
        }
        
        
        @objc private func processAqiHistory() {
            let totalTimePeriod: Double = 60*2  // 2 Minutes
            
            let fewMinsAgo = Date.now.addingTimeInterval(-totalTimePeriod)
            
            let interval: Double = 10           // 10 Seconds interval
            
            let steps = Int(floor(totalTimePeriod/interval))
            
            var dataPoints = [DataPoint]()
            
            //At every 'interval' only the last AQI update will be considered
            //'TotalTimePeriod' is the width of graph which will shown. Older updates will be ignored.
            
            for period in 1...steps {
                let cutoff = fewMinsAgo.addingTimeInterval(interval*Double(period)).timeIntervalSince1970
                if let index = cityAqiHistory.aqiHistory.firstIndex(where: { $0.timestamp.timeIntervalSince1970 > cutoff }), cityAqiHistory.aqiHistory.indices.contains(index-1) {
                    let aqi = cityAqiHistory.aqiHistory[index-1].value
                    dataPoints.append(DataPoint(x: Double(-(steps-period)*Int(interval)), y: Double(aqi)))
                }
            }
            
            self.viewDelegate?.update(history: dataPoints)
        }
    }
    
}

extension Result where Success == URLSessionWebSocketTask.Message {
    
    func parseMessage() throws -> [AQIJsonModel]  {
        let value = try get()
        
        guard case .string(let text) = value else {
            throw AQIMessageError.message("Unknown message received.")
        }
        
        guard let aqiModels: [AQIJsonModel] = try? JSONDecoder().decode([AQIJsonModel].self, from: text.data(using: .utf8)!) else {
            throw AQIMessageError.message("Unable to parse json")
        }
        
        return aqiModels
    }
}

enum AQIMessageError: Error {
    case message(String)
}
              
struct DataPoint {
    let x: Double
    let y: Double
}
