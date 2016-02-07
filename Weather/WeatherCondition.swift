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
    
    func backgroundImage()-> String{
        switch self{
        case .Rain:
            return "background_rain_blurry"
        case .Atmosphere:
            return "background_fog_blurry"
        case .Clear:
            return "background_sunny_blurry"
        case .Clouds:
            return "background_clouds_blurry"
        case .Snow:
            return "background_snow_blurry"
        default:
            return "background_fog_blurry"
        }
    }
}