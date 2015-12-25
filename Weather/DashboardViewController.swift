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
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!

    // image views
    @IBOutlet weak var backgroundImageView: UIImageView!

    // lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let cityName = "Nuernberg"
        let cityName = "Hof"

        let weatherAPIConnection = WeatherAPIConnection()
        weatherAPIConnection.featchCurrentWeather(cityName,
                                                  completionCallback: processReturnedWeatherJson)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.labelWeatherDescription.text = weatherDescription.uppercaseString
                }
            }
        }

        if let temperature = jsonData?.valueForKey("main")?.valueForKey("temp") as? Float
        {
            dispatch_async(dispatch_get_main_queue())
            {
                self.labelTemperature.text = String(format: "%.1f°", (temperature - 273.15))
            }
        }
    }
}