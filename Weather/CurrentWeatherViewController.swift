//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian on 20/12/15.
//  Copyright © 2015 FHWS. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController, ReloadViewController
{
    // text views
    @IBOutlet weak var labelCity:               UILabel!
    @IBOutlet weak var labelWeatherDescription: UILabel!
    @IBOutlet weak var minusLabel:              UILabel!
    @IBOutlet weak var labelTemperature:        UILabel!
    @IBOutlet weak var humidityLabel:           UILabel!
    @IBOutlet weak var pressureLabel:           UILabel!
    @IBOutlet weak var updateLabel:             UILabel!
    @IBOutlet weak var tempUnitLabel:           UILabel!

    //background image
    @IBOutlet weak var backgroundImageView:     UIImageView!

    // current city
    var city = "Wuerzburg"

    // lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let temp = Settings.getCity();
        if temp != nil && !temp!.isEmpty
        {
            city = temp!
        }
        loadWeather()
    }

    func loadWeather()
    {
        let weatherAPIConnection = WeatherAPIConnection(city: city)
        weatherAPIConnection.fetchCurrentWeather(processReturnedWeatherJson)
    }

    private func changeBackgroundImage(condition: WeatherCondition)
    {
        var image: String?

        if (condition == WeatherCondition.Rain)
        {
            image = "background_rain_blurry"
        }
        else if condition == WeatherCondition.Atmosphere
        {
            image = "background_fog_blurry"
        }
        else if condition == WeatherCondition.Clear
        {
            image = "background_sunny_blurry"
        }
        else if condition == WeatherCondition.Clouds
        {
            image = "background_clouds_blurry"
        }
        else if condition == WeatherCondition.Snow
        {
            image = "background_snow_blurry"
        }
        else
        {
            image = "background_fog_blurry"
        }


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
        guard let weather = weather else
        {
            return
        }

        print(weather)

        let normalTemperature: Double
        = TempUnit.convertKelvinTo(Double(weather.temperature), tempUnit: Settings.getTempUnit());
        let absTemperature = abs(normalTemperature)

        dispatch_async(dispatch_get_main_queue())
        {
            self.labelCity.text = weather.city
            self.labelWeatherDescription.text = weather.description?.capitalizedString
            self.labelTemperature.text = String(format: "%.1f", absTemperature)
            self.minusLabel.hidden = normalTemperature >= 0
            self.pressureLabel.text = String(weather.pressure)
            self.humidityLabel.text = String(weather.humidity)

            let dateFormatter = NSDateFormatter()
            let locale        = NSLocale.currentLocale()

            dateFormatter.locale = locale
            dateFormatter.dateFormat = "HH:mm dd.MM.YY"

            let formattedDate
            = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(weather.timestamp)))
            self.updateLabel.text = String(format: "Last update: %@", formattedDate)

            self.tempUnitLabel?.text = Settings.getTempUnit().viewRepresentation()
            if let condition = weather.weatherCondition
            {
                self.changeBackgroundImage(condition)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let controller = segue.destinationViewController as? SendReloadViewController
        {
            controller.setReloadViewController(self)
        }
    }

    func reload()
    {
        let temp = Settings.getCity();
        if temp != nil && !temp!.isEmpty
        {
            city = temp!
        }
        loadWeather()
    }
}