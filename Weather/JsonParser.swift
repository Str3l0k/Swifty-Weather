//
//  JsonParser.swift
//  Weather
//
//  Created by student on 06.02.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation

class JsonParser
{
    private init()
    {
    }

    static func parseWeather(jsonDict: NSDictionary) -> Weather?
    {
        // prefetch sub dictionaries
        let mainDictionary    = jsonDict.valueForKey("main")
        let weatherDictionary = jsonDict.valueForKey("weather")
        let windDictionary    = jsonDict.valueForKey("wind")
        let sysDictionary     = jsonDict.valueForKey("sys")

        guard weatherDictionary?.count > 0 else
        {
            return nil
        }

        // general info
        let id        = weatherDictionary?[0]?.valueForKey("id") as? Int
        let condition = weatherDictionary?[0]?.valueForKey("main") as? String
        let timestamp = jsonDict.valueForKey("dt") as? Int

        guard let _ = id, _ = timestamp else
        {
            return nil
        }

        // actual weather
        let temperature = mainDictionary?.valueForKey("temp") as? Float
        let pressure    = mainDictionary?.valueForKey("pressure") as? Int
        let humidity    = mainDictionary?.valueForKey("humidity") as? Int

        // additional information
        let sunrise     = sysDictionary?.valueForKey("sunrise") as? Int
        let sunset      = sysDictionary?.valueForKey("sunset") as? Int

        var wind: Wind?

        let windDirection = windDictionary?.valueForKey("deg") as? Int
        let windSpeed     = windDictionary?.valueForKey("speed") as? Float

        if let windSpeed = windSpeed
        {
            if let windDirection = windDirection
            {
                wind = Wind(directionDegrees: windDirection, speed: windSpeed)
            }
            else
            {
                wind = Wind(directionDegrees: -1, speed: windSpeed)
            }
        }

        var sunriseDate: NSDate?
        var sunsetDate:  NSDate?

        if let sunrise = sunrise, sunset = sunset
        {
            sunriseDate = NSDate(timeIntervalSince1970: NSTimeInterval(sunrise))
            sunsetDate = NSDate(timeIntervalSince1970: NSTimeInterval(sunset))
        }

        // strings
        let weatherName        = weatherDictionary?[0]?.valueForKey("main") as? String
        let weatherDescription = weatherDictionary?[0]?.valueForKey("description") as? String
        let city               = jsonDict.valueForKey("name") as? String

        // create weather object
        if let id = id, timestamp = timestamp
        {
            var weather = Weather(id: id, timestamp: timestamp)
            if let condition = condition
            {
                weather.weatherCondition = WeatherCondition.init(raw: condition)
            }

            // set data
            if let temperature = temperature
            {
                weather.temperature = Double(temperature)
            }
            if let pressure = pressure
            {
                weather.pressure = pressure
            }
            if let humidity = humidity
            {
                weather.humidity = humidity
            }
            weather.sunrise = sunriseDate
            weather.sunset = sunsetDate

            weather.name = weatherName
            weather.description = weatherDescription
            weather.city = city
            weather.wind = wind
            return weather
        }


        return nil
    }
}