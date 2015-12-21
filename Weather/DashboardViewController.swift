//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian on 20/12/15.
//  Copyright © 2015 FHWS. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        featchWeatherInWuerzburg("Wuerzburg")
        featchWeatherInWuerzburg("Nuernberg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func featchWeatherInWuerzburg(city:String)
    {
        let weatherURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=2de143494c0b295cca9337e1e96b00e0") // todo
        let request = NSURLRequest(URL: weatherURL!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        session.dataTaskWithRequest(request,
            completionHandler:
            {
                (data, resopnse, error) in
                
                guard data != nil else
                {
                    return
                }
                
                var jsonResult:NSDictionary!
                
                do
                {
                    jsonResult = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)!
                }
                catch
                {
                    print(error)
                }
                
                guard jsonResult != nil else
                {
                    return
                }
                
                print(jsonResult)
        }).resume()
    }
}