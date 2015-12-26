//
// Created by Sebastian on 24/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class WeatherAPIConnection
{
    // name based location
    let city: String

    // constructor
    init(city: String)
    {
        self.city = city
    }

    func fetchCurrentWeather(completionCallback: (result:NSDictionary?) -> Void) // todo let completionCallback actual weather object, not raw dictionary
    {
        let weatherURL = createCurrentWeatherURL()

        if let weatherURL = weatherURL
        {
            let task = OpenWeatherAPIHelper.createURLSession(weatherURL,
                                                             completionHandler:
                                                             {
                                                                 (data, response, error) in
                                                                 completionCallback(result: self.processRequestResult(data, response: response, error: error))
                                                             })
            task.resume()
        }
        // todo more precise error handling is necessary, maybe add error id to callback
    }

    func fetchCurrentWeather(completionCallback: (weather:Weather) -> Void)
    {
//        completionCallback(weather: Weather())
    }

    func fetchFiveDayWeatherForecast(completionCallback: (weatherForecast:[WeatherDay]) -> Void)
    {
        completionCallback(weatherForecast: [WeatherDay()]) // todo
    }

    func fetchDailyWeatherForecast(count: Int, completionCallback: (forecast:[WeatherDay]) -> Void)
    {
        completionCallback(forecast: [WeatherDay()]) // todo
    }

    func parseWeatherFromDictionary(jsonDict: NSDictionary) -> Weather?
    {
        return nil
    }

    private func createCurrentWeatherURL() -> NSURL?
    {
        return OpenWeatherAPIHelper.createCurrentWeatherApiCall(city,
                                                                applicationID: OpenWeatherAPISession.APPLICATION_ID)
    }

    private func createDailyWeatherForecast(dayCount: Int) -> NSURL?
    {
        return nil
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