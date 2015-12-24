//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian on 20/12/15.
//  Copyright © 2015 FHWS. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController
{

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!

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

                                                          print(jsonResult)

                                                          if let name = jsonResult.valueForKey("name") as? String
                                                          {
                                                              print(name)

                                                              dispatch_async(dispatch_get_main_queue())
                                                              {
                                                                  self.labelCity.text = name
                                                              }
                                                          }

                                                          if let temperature = jsonResult.valueForKey("main")?.valueForKey("temp") as? Float
                                                          {
                                                              dispatch_async(dispatch_get_main_queue())
                                                              {
                                                                  self.labelTemperature.text = String(format: "%.1f", (temperature - 273.15))
                                                              }
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