//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

struct Weather
{
    // main identifier
    let id:          Int
    let timestamp:   Int

    // actual information
    let temperatue:  Float
    let pressure:    Int
    let humidity:    Int

    // text information
    let name:        String
    let description: String

    // constructor
    init(id: Int, timestamp: Int, temperature: Float, pressure: Int, humidity: Int, name: String, description: String)
    {
        self.id = id
        self.timestamp = timestamp

        self.temperatue = temperature
        self.pressure = pressure
        self.humidity = humidity

        self.name = name
        self.description = description
    }
}
