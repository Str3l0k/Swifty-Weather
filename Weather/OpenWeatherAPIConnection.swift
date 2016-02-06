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
    
    func fetchHourlyForecast(completionCallback: (weatherForecast: [Weather]) -> Void){
        let weatherURL = OpenWeatherAPIURLHelper.createHourlyWeatherForecastApiCallURL(city, applicationID: OpenWeatherAPISession.APPLICATION_ID)
        
        if let weatherURL = weatherURL {
            let urlTask = OpenWeatherAPIURLHelper.createURLSessionTask(weatherURL, completionHandler: {
                (data, response, error) in
                let weather = self.completionHandlerHourlyWeather(data, response: response, error: error)
                completionCallback(weatherForecast: weather)
            })
            urlTask.resume();
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
            weather = JsonParser.parseWeather(dictionary)
        }

        return weather
    }
    
    private func completionHandlerHourlyWeather(data: NSData?, response: NSURLResponse?, error: NSError?) -> [Weather] {
        var forecast = [Weather]()
        let jsonDictionary = self.processRequestResult(data, response: response, error: error)
        let listDictionary = jsonDictionary?.valueForKey("list")
        if let listDictionary = listDictionary {
            for var index:Int = 0; index < listDictionary.count; ++index {
                let singleWeatherDic = listDictionary[index]
                if let weatherDic = singleWeatherDic as? NSDictionary{
                    let weather = JsonParser.parseWeather(weatherDic)
                    if let weather = weather{
                        forecast.append(weather);
                    }
                }
            }
        }
        return forecast
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

        guard data != nil && response != nil else{
            return jsonResult
        }

        do {
            jsonResult = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
        } catch {
            print(error)
        }

        return jsonResult
    }

}