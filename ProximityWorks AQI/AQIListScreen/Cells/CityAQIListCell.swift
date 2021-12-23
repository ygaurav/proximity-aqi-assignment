//
//  AQIListCell.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import UIKit

class CityAQIListCell: UICollectionViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var updatedOnLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bandChangeImageView: UIImageView!
    
    static let reuseIdentifier = "AQIListCell"
    
    func setup(_ model: AQIUpdate) {
        stackView.backgroundColor = .systemGray5
        stackView.layer.cornerRadius = 5
        cityLabel.text  = model.city
        aqiLabel.textColor = model.bandColor
        updatedOnLabel.text = model.updateTime
        
        aqiLabel.text = String(format: "%.2f", model.latestValue)
        
        if model.didBandChange {
            bandChangeImageView.isHidden = false
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular, scale: .small)
            let image = UIImage(systemName: model.aqiBandImproved ? "arrow.up" : "arrow.down", withConfiguration: config)
            bandChangeImageView.image = image
            bandChangeImageView.tintColor = model.aqiBandImproved ? .systemGreen : .systemRed
        } else {
            bandChangeImageView.isHidden = true
        }
    }

}
