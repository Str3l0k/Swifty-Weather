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
    var temperature = 0.0
    var pressure    = 0
    var humidity    = 0

    // optional information
    var sunrise:     NSDate?
    var sunset:      NSDate?
    var wind:        Wind?

    // text information
    var city:        String?
    var name:        String?
    var description: String?

    var weatherCondition: WeatherCondition?

    // constructor
    init(id: Int, timestamp: Int)
    {
        self.id = id
        self.timestamp = timestamp
    }
}
