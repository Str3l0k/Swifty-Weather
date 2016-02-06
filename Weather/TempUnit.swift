//
//  TempUnit.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation

public enum TempUnit : String {
    case Fahrenheit = "FAHRENHEIT"
    case Celsius = "CELSIUS"
    case Kelvin = "KELVIN"
    public init?(raw: String) {
        self.init(rawValue: raw)
    }
    public static func KelvinToCelcius(kelvin: Double) -> Double{
        return kelvin - 273.15
    }
    public static func KelvinToFahrenheit(kelvin: Double) -> Double{
        return (KelvinToCelcius(kelvin))*1.8000 + 32.00
    }
    public static func convertKelvinTo(kelvin: Double, tempUnit: TempUnit) -> Double{
        switch tempUnit{
        case .Celsius:
            return KelvinToCelcius(kelvin)
        case .Fahrenheit:
            return KelvinToFahrenheit(kelvin)
        default:
            return kelvin;
        }
    }
    public func viewRepresentation() -> String{
        switch self{
        case .Kelvin:
            return "K"
        case .Fahrenheit:
            return "°F"
        case .Celsius:
            return "°C"
        }
        
    }
}