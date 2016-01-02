//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian on 20/12/15.
//  Copyright © 2015 FHWS. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController
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
    let city = "Nuernberg"

    // lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let weatherAPIConnection = WeatherAPIConnection(city: city)
        weatherAPIConnection.fetchCurrentWeather(processReturnedWeatherJson)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)

        changeBackgroundImage()
    }


    private func changeBackgroundImage()
    {
        UIView.transitionWithView(self.backgroundImageView,
                                  duration: 1,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations:
                                  {
                                      self.backgroundImageView.image = UIImage(named: "Background Sunny")
                                      self.blurEffectView.alpha = 0.9
                                  },
                                  completion: nil
        )
    }

    //
    private func processReturnedWeatherJson(weather: Weather?)
    {
        guard weather != nil else
        {
            return
        }

        dispatch_async(dispatch_get_main_queue())
        {
            self.labelCity.text = weather!.city
            self.labelWeatherDescription.text = weather!.description.capitalizedString
            self.labelTemperature.text = String(format: "%.1f", (weather!.temperature - 273.15))
        }
    }
}