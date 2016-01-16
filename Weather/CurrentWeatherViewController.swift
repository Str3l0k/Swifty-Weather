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
    @IBOutlet weak var minusLabel:              UILabel!
    @IBOutlet weak var labelTemperature:        UILabel!

    //background image
    @IBOutlet weak var backgroundImageView:     UIImageView!

    // current city
    let city = "Wuerzburg"

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

    var counter = 0;
    private func changeBackgroundImage()
    {
        var image:String?
        
        if(counter % 2 == 0)
        {
            image = "background_rain_blurry"
        }
        else
        {
            image = "background_fog_blurry"
        }
        
        counter += 1
        
        UIView.transitionWithView(self.backgroundImageView,
                                  duration: 1,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations:
                                  {
                                      self.backgroundImageView.image = UIImage(named: image!)
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

        print(weather)

        let normalTemperature = weather!.temperature - 273.15
        let absTemperature    = abs(normalTemperature)

        dispatch_async(dispatch_get_main_queue())
        {
            self.labelCity.text = weather!.city
            self.labelWeatherDescription.text = weather!.description.capitalizedString
            self.labelTemperature.text = String(format: "%.1f", absTemperature)
            self.minusLabel.hidden = normalTemperature >= 0
        }
    }
}