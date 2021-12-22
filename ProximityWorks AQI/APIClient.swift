//
//  APIClient.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import Foundation


class APIClient {
    static let shared = APIClient()
    
    func websocketTask(with url: URL) -> URLSessionWebSocketTask {
        
        let urlsession = URLSession(configuration: .default)
        
        return urlsession.webSocketTask(with: url)
    }
}
