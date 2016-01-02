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

    // todo more precise error handling is necessary, maybe add error id to callback

    // public access
    func fetchCurrentWeather(completionCallback: (weather:Weather?) -> Void)
    {
        if let weatherURL = createCurrentWeatherURL()
        {
            let urlTask = OpenWeatherAPIURLHelper.createURLSessionTask(weatherURL,
                                                                       completionHandler:
                                                                       {
                                                                           (data, response, error) in

                                                                           let weather
                                                                           = self.completionHandlerCurrentWeather(data,
                                                                                                                  response: response,
                                                                                                                  error: error)
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



    // ================
    // completion handler
    // ================
    private func completionHandlerCurrentWeather(data: NSData?, response: NSURLResponse?, error: NSError?) -> Weather?
    {
        var weather: Weather?

        if let dictionary = self.processRequestResult(data, response: response, error: error)
        {
            weather = self.parseWeatherFromDictionary(dictionary)
        }

        return weather
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

    private func parseWeatherFromDictionary(jsonDict: NSDictionary) -> Weather?
    {
        var weather: Weather?

        // prefetch
        let mainDictionary     = jsonDict.valueForKey("main")
        let weatherDictionary  = jsonDict.valueForKey("weather")

        // general info
        let id                 = jsonDict.valueForKey("id") as? Int
        let timestamp          = jsonDict.valueForKey("dt") as? Int

        // actual weather
        let temperature        = mainDictionary?.valueForKey("temp") as? Float
        let pressure           = mainDictionary?.valueForKey("pressure") as? Int
        let humidity           = mainDictionary?.valueForKey("humidity") as? Int

        // strings
        let weatherName        = weatherDictionary?[0]?.valueForKey("main") as? String
        let weatherDescription = weatherDictionary?[0]?.valueForKey("description") as? String

        if let id = id, timestamp = timestamp, temperature = temperature, pressure = pressure, humidity = humidity, name = weatherName, description = weatherDescription
        {
            weather = Weather(id: id, timestamp: timestamp,
                              temperature: temperature, pressure: pressure, humidity: humidity,
                              city: city, name: name, description: description)
        }

        return weather
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