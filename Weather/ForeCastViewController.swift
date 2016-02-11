//
//  ForeCastViewController.swift
//  Weather
//
//  Created by student on 06.02.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

class ForeCastViewController: UITableViewController
{
    private var forecast: [Weather] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return forecast.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let weather = forecast[indexPath.row]
        let cell    = tableView.dequeueReusableCellWithIdentifier("WeatherCellIdentifier") as! WeatherTableViewCell
        cell.configureCellForWeather(weather)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }

    func setForecast(forecast: [Weather])
    {
        self.forecast = forecast;
        refreshUI()
    }

    func refreshUI()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        });
    }
}
