//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by student on 06.02.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewCell : UITableViewCell{
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    
    func configureCellForWeather(weather: Weather){
        let dateFormatter = NSDateFormatter()
        let locale        = NSLocale.currentLocale()
        
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "HH:mm"
        
        let formattedDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(weather.timestamp)))
        lblTime.text = String(format: "%@:", formattedDate)
        
        let normalTemperature:Double = TempUnit.convertKelvinTo(Double(weather.temperature), tempUnit: Settings.getTempUnit());
        
        
        lblTemperature.text = String(format: "%.1f%@", normalTemperature, Settings.getTempUnit().viewRepresentation())
        lblCondition.text = weather.description?.capitalizedString
    }
}