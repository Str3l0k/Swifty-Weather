//
//  Settings.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation

class Settings {
    private init(){ //abstract class in swift; LOL
    }
    
    static let CITY:String = "CITY"
    static let TEMPERATURE_UNIT: String = "TEMPERATURE_UNIT"
    
    static func setCity(city: String) {
        UserDefaultsHelper.saveUserDefault(CITY, value: city)
    }
    
    static func getCity() -> String {
        if let city = UserDefaultsHelper.loadUserDefaults(CITY) {
            if city.isEmpty {
                return "wuerzburg"
            }
            return city
        } else {
            return "wuerzburg"
        }
    }
    
    static func setTempUnit(tempUnit: TempUnit) {
        UserDefaultsHelper.saveUserDefault(TEMPERATURE_UNIT, value: tempUnit.rawValue)
    }
    
    static func getTempUnit() -> TempUnit {
        let value: String? = UserDefaultsHelper.loadUserDefaults(TEMPERATURE_UNIT)
        
        if let value = value {
            if let tempUnit = TempUnit.init(raw: value) {
                return tempUnit
            }
        }
        return TempUnit.Celsius
    }
}