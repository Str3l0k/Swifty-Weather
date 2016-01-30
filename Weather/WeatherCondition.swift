//
//  WeatherCondition.swift
//  Weather
//
//  Created by student on 30.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation

public enum WeatherCondition : String {
    case Thunderstorm = "Thunderstorm"
    case Drizzle = "Drizzle"
    case Rain = "Rain"
    case Snow = "Snow"
    case Atmosphere = "Atmosphere"
    case Clear = "Clear"
    case Clouds = "Clouds"
    case Extreme = "Extreme"
    case Additional = "Additional"
    public init?(raw: String) {
        self.init(rawValue: raw)
    }
}