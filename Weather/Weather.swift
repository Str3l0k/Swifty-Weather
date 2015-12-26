//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

struct Weather
{
    let id: Int

    // actual information
    let temperatue: Float
    let pressure: Int
    let humidity: Int

    // text information
//    let name:String
//    let description:String

    init(id: Int, temperature: Float, pressure: Int, humidity: Int)
    {
        self.id = id

        self.temperatue = temperature
        self.pressure = pressure
        self.humidity = humidity
    }
}
