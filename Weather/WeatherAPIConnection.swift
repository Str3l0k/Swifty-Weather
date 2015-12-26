//
// Created by Sebastian on 24/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class WeatherAPIConnection
{
    static let currentWeatherApiCall = "http://api.openweathermap.org/data/2.5/weather?q="
    static let hourlyForecastWeatherApiCall = "http://api.openweathermap.org/data/2.5/forecast?q="
    static let dailyForecastWeatherApiCall = "http://api.openweathermap.org/data/2.5/forecast/daily?q="

    static let APPLICATION_ID = "2de143494c0b295cca9337e1e96b00e0"

    func featchCurrentWeather(city: String, completionCallback: (result:NSDictionary?) -> Void) // todo let completionCallback actual weather object, not raw dictionary
    {
        let weatherURL = NSURL(string: "\(WeatherAPIConnection.currentWeatherApiCall)\(city)&appid=\(WeatherAPIConnection.APPLICATION_ID)") // todo
        let request = NSURLRequest(URL: weatherURL!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        session.dataTaskWithRequest(request,
                                    completionHandler:
                                    {
                                        (data, response, error) in
                                        completionCallback(result: self.processRequestResult(data, response: response, error: error))
                                    }).resume()
        // todo more precise error handling is necessary, maybe add error id to callback
    }

    private func processRequestResult(data: NSData?, response: NSURLResponse?, error: NSError?) -> NSDictionary?
    {
        var jsonResult: NSDictionary!

        guard data != nil && response != nil else
        {
            return jsonResult
        }
        
        do
        {
            jsonResult = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
        } catch
        {
            print(error)
        }

        // todo remove debug output
        print(jsonResult)

        return jsonResult
    }
}