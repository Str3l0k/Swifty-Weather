//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian on 20/12/15.
//  Copyright © 2015 FHWS. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController
{
    // text views
    @IBOutlet weak var labelCity:               UILabel!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var labelTemperature:        UILabel!

    // image views
    @IBOutlet weak var blurEffectView:          UIVisualEffectView!
    // todo manual alpha level for different weather (fog 0.7, rain 0.9, sunny 0.9)
    @IBOutlet weak var backgroundImageView:     UIImageView!

    // api session instance
    let weatherApiSession = OpenWeatherAPISession()

    // lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        backgroundImageView.image = UIImage(named: "Sunny")

//        let cityName = "Nuernberg"
        let cityName = "Hof"

        let weatherAPIConnection = WeatherAPIConnection(city: cityName)
        weatherAPIConnection.fetchCurrentWeather(processReturnedWeatherJson)
        weatherAPIConnection.fetchDailyForecast(10,
                                                completionCallback:
                                                       {
                                                           (forecast) in

                                                       })
    }

    //
    private func processReturnedWeatherJson(jsonData: NSDictionary?)
    {
        guard jsonData != nil else
        {
            // todo print error
            return
        }

        if let name = jsonData?.valueForKey("name") as? String
        {
            print(name)

            dispatch_async(dispatch_get_main_queue())
            {
                self.labelCity.text = name
            }
        }

        // weather information is a json array which may contain multiple weather objects
        // todo create weather object and wrap every entry in the returned json array
        if let weatherDictionary = jsonData?.valueForKey("weather")?[0]
        {
            if let weatherDescription = weatherDictionary.valueForKey("description") as? String
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    self.labelWeatherDescription.text = weatherDescription.capitalizedString
                }
            }
        }

        if let temperature = jsonData?.valueForKey("main")?.valueForKey("temp") as? Float
        {
            dispatch_async(dispatch_get_main_queue())
            {
                self.labelTemperature.text = String(format: "%.1f", (temperature - 273.15))
            }
        }
    }
}