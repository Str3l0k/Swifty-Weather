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
    @IBOutlet weak var mainView:                UIView!

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

    var foreCastViewController: ForeCastViewController?

    // lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadWeather()
    }

    func loadWeather()
    {
        let weatherAPIConnection = WeatherAPIConnection(city: Settings.getCity())
        weatherAPIConnection.fetchCurrentWeather(processReturnedWeatherJson)
        weatherAPIConnection.fetchHourlyForecast(processReturnedWeatherForecast)
    }

    func processReturnedWeatherForecast(weather: [Weather])
    {
        if let controller = foreCastViewController
        {
            controller.setForecast(weather);
        }
    }

    private func changeBackgroundImage(condition: WeatherCondition)
    {
        UIView.transitionWithView(self.backgroundImageView,
                                  duration: 2,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations:
                                  {
                                      self.mainView.alpha = 0
                                      self.mainView.alpha = 1
                                      self.backgroundImageView.image = UIImage(named: condition.backgroundImage())
                                  },
                                  completion: nil
        )
    }

    private func processReturnedWeatherJson(weather: Weather?)
    {
        guard let weather = weather else {
            return
        }

        print(weather)

        let normalTemperature: Double
        = TemperatureUnit.convertKelvinTo(Double(weather.temperature), tempUnit: Settings.getTempUnit());
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
        if let controller = segue.destinationViewController as? SendReloadViewControllerProtocol
        {
            controller.setReloadViewController(self)
        }
        if let controller = segue.destinationViewController as? ForeCastViewController
        {
            foreCastViewController = controller
        }
    }
}

// MARK Reload

extension CurrentWeatherViewController: ReloadViewControllerProtocol
{
    func reload()
    {
        loadWeather()
    }
}