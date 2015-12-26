//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

struct Wind
{
    // data
    let directionDegrees: Int
    let speed: Float

    // constructor
    init(directionDegrees: Int, speed: Float)
    {
        self.directionDegrees = directionDegrees
        self.speed = speed
    }
}
