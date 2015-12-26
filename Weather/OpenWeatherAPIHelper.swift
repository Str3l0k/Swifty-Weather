//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class OpenWeatherAPIHelper
{
    static let currentWeatherApiCall        = "http://api.openweathermap.org/data/2.5/weather?q="
    static let hourlyForecastWeatherApiCall = "http://api.openweathermap.org/data/2.5/forecast?q="
    static let dailyForecastWeatherApiCall  = "http://api.openweathermap.org/data/2.5/forecast/daily?q="

    // private helper
    static func createCurrentWeatherApiCall(city: String, applicationID: String) -> NSURL?
    {
        return NSURL(string: createURLString(city, applicationID: applicationID)) // todo distinguish between current, hourly and daily weather
    }

    static func createDailyWeatherForecastApiCall(city: String, applicationID: String, dayCount: Int)
    {
        return NSURL(string: createURLString(city, applicationID: applicationID))
    }

    static func createURLSession(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
    {
        let request = NSURLRequest(URL: url)
        let config  = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        return session.dataTaskWithRequest(request, completionHandler: completionHandler)
    }

    // private helper
    private static func createCityURLString(city: String) -> String
    {
        return "\(OpenWeatherAPIHelper.currentWeatherApiCall)\(city)"
    }

    private static func createApplicationIDURLString(appID: String) -> String
    {
        return "&appid=\(applicationID)"
    }

    private static func createURLString(city: String, applicationID: String) -> String
    {
        return "\(createCityURLString(city))\(createApplicationIDURLString(applicationID))"
    }
}
