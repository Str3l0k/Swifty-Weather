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
    // MARK: - view outlets
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

    // MARK: - lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fadeOutBackground()
        loadWeather()
    }

    // MARK: - private functions
    private func loadWeather()
    {
        let weatherAPIConnection = WeatherAPIConnection(city: Settings.getCity())
        weatherAPIConnection.fetchCurrentWeather(processReturnedWeatherJson)
        weatherAPIConnection.fetchHourlyForecast(processReturnedWeatherForecast)
    }

    private func processReturnedWeatherForecast(weather: [Weather])
    {
        if let controller = foreCastViewController
        {
            controller.setForecast(weather);
        }
    }

    private func changeBackgroundImage(condition: WeatherCondition)
    {
        UIView.transitionWithView(self.backgroundImageView,
                                  duration: 1,
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
    
    private func fadeOutBackground()
    {
        UIView.transitionWithView(self.backgroundImageView,
            duration: 1,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations:
            {
                self.mainView.alpha = 1
                self.mainView.alpha = 0
            },
            completion: nil
        )
    }
    private func fadeInBackground()
    {
        UIView.transitionWithView(self.backgroundImageView,
            duration: 1,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations:
            {
                self.mainView.alpha = 0
                self.mainView.alpha = 1
            },
            completion: nil
        )
    }

    private func processReturnedWeatherJson(weather: Weather?)
    {
        guard let weather = weather else {
            dispatch_async(dispatch_get_main_queue())
            {
                self.fadeInBackground()
                self.labelCity.text = "Not Found"
                self.labelWeatherDescription.text = ""
                self.labelTemperature.text = "0"
                self.minusLabel.hidden = true
                self.pressureLabel.text = "0"
                self.humidityLabel.text = "0"
            }
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

    // MARK: - overwritten functions
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

// MARK: - Reload protocol
extension CurrentWeatherViewController: ReloadViewControllerProtocol
{
    func reload()
    {
        fadeOutBackground()
        loadWeather()
    }
}