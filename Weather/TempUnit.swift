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
    public init?(raw: String) {
        self.init(rawValue: raw)
    }
}