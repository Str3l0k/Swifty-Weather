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

    // public access
    func fetchCurrentWeather(completionCallback: (result:NSDictionary?) -> Void) // todo let completionCallback actual weather object, not raw dictionary
    {
        if let weatherURL = createCurrentWeatherURL()
        {
            let task = OpenWeatherAPIURLHelper.createURLSessionTask(weatherURL,
                                                                    completionHandler:
                                                                    {
                                                                        (data, response, error) in
                                                                        completionCallback(result: self.processRequestResult(data, response: response, error: error))
                                                                    })
            task.resume()
        }
        // todo more precise error handling is necessary, maybe add error id to callback
    }

    func fetchCurrentWeather(completionCallback: (weather:Weather?) -> Void)
    {
        if let weatherURL = createCurrentWeatherURL()
        {
            let urlTask = OpenWeatherAPIURLHelper.createURLSessionTask(weatherURL,
                                                                       completionHandler:
                                                                       {
                                                                           (data, response, error) in

                                                                           var weather: Weather?

                                                                           if let dictionary = self.processRequestResult(data, response: response, error: error)
                                                                           {
                                                                               weather = self.parseWeatherFromDictionary(dictionary)
                                                                           }

                                                                           completionCallback(weather: weather)
                                                                       })
            urlTask.resume()
        }
    }

    func fetchFiveDayHourlyForecast(completionCallback: (weatherForecast:[WeatherDay]) -> Void)
    {
        completionCallback(weatherForecast: [WeatherDay()]) // todo
    }

    func fetchDailyForecast(count: Int, completionCallback: (forecast:[WeatherDay]) -> Void)
    {
        let weatherURL = createDailyWeatherForecastURL(count)

        if let weatherURL = weatherURL
        {
            let task = OpenWeatherAPIURLHelper.createURLSessionTask(weatherURL,
                                                                    completionHandler:
                                                                    {
                                                                        (data, response, error) in

                                                                        self.processRequestResult(data, response: response, error: error)
                                                                    })
            task.resume()
        }

        completionCallback(forecast: [WeatherDay()]) // todo
    }

    func parseWeatherFromDictionary(jsonDict: NSDictionary) -> Weather?
    {
        return nil
    }

    // ================
    // private helper
    // ================
    private func createCurrentWeatherURL() -> NSURL?
    {
        return OpenWeatherAPIURLHelper.createCurrentWeatherApiCallURL(city,
                                                                      applicationID: OpenWeatherAPISession.APPLICATION_ID)
    }

    private func createDailyWeatherForecastURL(dayCount: Int) -> NSURL?
    {
        return OpenWeatherAPIURLHelper.createDailyWeatherForecastApiCallURL(city,
                                                                            applicationID: OpenWeatherAPISession.APPLICATION_ID,
                                                                            dayCount: dayCount)
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