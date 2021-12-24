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
        
        //Known bug: - Timer will be suspended when application is put in background. Need to fix that.
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
            let dataPoints = cityAqiHistory.aqiHistory.segragate(withInterval: 10, overPeriod: 60*2)
            
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

extension Array where Element == AQI {
    
    func segragate(withInterval interval: Double, overPeriod period: Double) -> [DataPoint] {
        let fewMinsAgo = Date.now.addingTimeInterval(-period)
        
        let steps = Int(floor(period/interval))
        
        assert(steps > 1)
        
        var dataPoints = [DataPoint]()
        
        //At every 'interval' only the last AQI update will be considered
        //'TotalTimePeriod' is the width of graph which will shown. Older updates will be ignored.
        
        for period in 1...steps {
            let cutoff = fewMinsAgo.addingTimeInterval(interval*Double(period))
            
            if let aqi = last(where: { $0.timestamp.timeIntervalSince1970 < cutoff.timeIntervalSince1970 }) {
                let dataPoint = DataPoint(x: Double(-(steps-period)*Int(interval)), y: Double(aqi.value))
                dataPoints.append(dataPoint)
            }
        }
        
        return dataPoints
    }
    
}

enum AQIMessageError: Error {
    case message(String)
}
              
struct DataPoint {
    let x: Double
    let y: Double
}
