//
//  AQIListRouter.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 22/12/21.
//

import Foundation
import UIKit

protocol AQIListRouter {
    func showGraph(for: CityAQIHistory)
}

extension AQIListViewController {
    
    class Router: AQIListRouter {
        
        weak var source: UIViewController?
        
        func showGraph(for aqiHistory: CityAQIHistory) {
            guard let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CityAQIGraphViewController") as? CityAQIGraphViewController else { fatalError("Unable to instantiate view controller with name 'CityAQIGraphViewController' ") }
            
            let viewModel = CityAQIGraphViewController.ViewModel(aqiHistory: aqiHistory)
            viewModel.viewDelegate = viewController
            
            viewController.viewModel = viewModel
            
            source?.present(viewController, animated: true, completion: nil)
        }
        
    }
    
}
