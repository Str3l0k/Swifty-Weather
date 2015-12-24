//
// Created by Sebastian on 24/12/15.
// Copyright (c) 2015 FHWS. All rights reserved.
//

import Foundation

class WeatherAPIConnection
{
    func featchWeatherInWuerzburg(city: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        let weatherURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=2de143494c0b295cca9337e1e96b00e0") // todo
        let request = NSURLRequest(URL: weatherURL!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        // todo change so only the dictionary is return to the completion callback
    }
}