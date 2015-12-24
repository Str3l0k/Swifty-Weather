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

    @IBOutlet weak var labelCity: UITextField!
    @IBOutlet weak var labelTemperature: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let weatherAPIConnection = WeatherAPIConnection()
        weatherAPIConnection.featchWeatherInWuerzburg("Wuerzburg",
                                                      completionHandler:
                                                      {
                                                          (data, response, error) in

                                                          guard data != nil else
                                                          {
                                                              return
                                                          }

                                                          var jsonResult: NSDictionary!

                                                          do
                                                          {
                                                              jsonResult = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)!
                                                          } catch
                                                          {
                                                              print(error)
                                                          }

                                                          guard jsonResult != nil else
                                                          {
                                                              return
                                                          }

                                                          if let name = jsonResult.valueForKey("name") as? String
                                                          {
                                                              self.labelCity.text = name
                                                          }

                                                          if let temperature = jsonResult.valueForKey("main")?.valueForKey("temp") as? Float
                                                          {
                                                              self.labelTemperature.text = "\(temperature - 273.15)"
                                                          }
                                                      })

//        featchWeatherInWuerzburg("Wuerzburg")
//        featchWeatherInWuerzburg("Nuernberg")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}