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

                                                                        completionCallback(forecast: [WeatherDay()]) // todo
                                                                    })
            task.resume()
        }
    }

    // ====================
    // completion handler
    // ====================
    private func completionHandlerCurrentWeather(data: NSData?, response: NSURLResponse?, error: NSError?) -> Weather?
    {
        var weather: Weather?

        if let dictionary = self.processRequestResult(data, response: response, error: error)
        {
            weather = self.parseCurrentWeatherFromDictionary(dictionary)
        }

        return weather
    }

    // ================
    // private helper
    // ================
    private func createCurrentWeatherURL() -> NSURL?
    {
        return OpenWeatherAPIURLHelper.createCurrentWeatherApiCallURL(city, applicationID: OpenWeatherAPISession.APPLICATION_ID)
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

        return jsonResult
    }

    private func parseCurrentWeatherFromDictionary(jsonDict: NSDictionary) -> Weather?
    {
        var weather: Weather?

        // prefetch sub dictionaries
        let mainDictionary    = jsonDict.valueForKey("main")
        let weatherDictionary = jsonDict.valueForKey("weather")
        let windDictionary    = jsonDict.valueForKey("wind")
        let sysDictionary     = jsonDict.valueForKey("sys")
//
//        guard let _ = mainDictionary, _ = weatherDictionary, _ = sysDictionary, _ = windDictionary else
//        {
//            return nil
//        }

        guard weatherDictionary?.count > 0 else
        {
            return nil
        }

        // general info
        let id        = weatherDictionary?[0]?.valueForKey("id") as? Int
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
            weather = Weather(id: id, timestamp: timestamp)
        }

        // set data
        if let temperature = temperature, pressure = pressure, humidity = humidity
        {
            weather?.temperature = Double(temperature)
            weather?.pressure = pressure
            weather?.humidity = humidity
        }

        if let sunrise = sunriseDate, sunset = sunsetDate
        {
            weather?.sunrise = sunrise
            weather?.sunset = sunset
        }

        if let name = weatherName, description = weatherDescription, city = city
        {
            weather?.name = name
            weather?.description = description
            weather?.city = city
        }

        if let wind = wind
        {
            weather?.wind = wind
        }

        return weather
    }
}