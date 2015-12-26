//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class OpenWeatherAPISession
{
    static let APPLICATION_ID = "2de143494c0b295cca9337e1e96b00e0"

    func createNewOpenWeatherAPIConnection(city: String) -> WeatherAPIConnection
    {
        return WeatherAPIConnection(city: city) // todo
    }
}
