//
// Created by Sebastian on 26/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class OpenWeatherAPIURLHelper
{
    private static let currentWeatherApiCallFormat        = "http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@"
    private static let hourlyForecastWeatherApiCallFormat = "http://api.openweathermap.org/data/2.5/forecast?q=%@&appid=%@"
    private static let dailyForecastWeatherApiCallFormat  = "http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&appid=%@&cnt=%d"

    // private helper
    static func createCurrentWeatherApiCallURL(city: String, applicationID: String) -> NSURL?
    {
        let cityURLString = createCurrentWeatherCityURLString(city, appID: applicationID)

        return NSURL(string: cityURLString)
    }

    static func createHourlyWeatherForecastApiCallURL(city: String, applicationID: String) -> NSURL?
    {
        let cityURLString = createHourlyForecastCityURLString(city, appID: applicationID)

        return NSURL(string: cityURLString)
    }

    static func createDailyWeatherForecastApiCallURL(city: String, applicationID: String, dayCount: Int) -> NSURL?
    {
        let cityURLString = createDailyForecastCityURLString(city, appID: applicationID, dayCount: dayCount)

        return NSURL(string: cityURLString)
    }

    static func createURLSessionTask(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask // todo extract to different helper
    {
        let request = NSURLRequest(URL: url)
        let config  = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        return session.dataTaskWithRequest(request, completionHandler: completionHandler)
    }

    // private helper
    private static func createCurrentWeatherCityURLString(city: String, appID: String) -> String
    {
        return String(format: OpenWeatherAPIURLHelper.currentWeatherApiCallFormat, city, appID)
    }

    private static func createHourlyForecastCityURLString(city: String, appID: String) -> String
    {
        return String(format: OpenWeatherAPIURLHelper.hourlyForecastWeatherApiCallFormat, city, appID)
    }

    private static func createDailyForecastCityURLString(city: String, appID: String, dayCount: Int) -> String
    {
        return String(format: OpenWeatherAPIURLHelper.dailyForecastWeatherApiCallFormat, city, appID, dayCount)
    }
}
