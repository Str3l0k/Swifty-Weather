//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by student on 20.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

public class SettingsTableViewController : UITableViewController{
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var Celsius: UITableViewCell!
    @IBOutlet weak var Fahrenheit: UITableViewCell!
    @IBOutlet weak var Kelvin: UITableViewCell!
    
    let tempUnitSection = 1
    
    public override func viewDidLoad() {
        CityTextField.text = Settings.getCity()
        
        let currentTempUnit = Settings.getTempUnit()
        if currentTempUnit == TempUnit.Fahrenheit {
            Fahrenheit.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else if currentTempUnit == TempUnit.Kelvin {
            Kelvin.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            Celsius.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == tempUnitSection {
            Fahrenheit.accessoryType = UITableViewCellAccessoryType.None
            Celsius.accessoryType = UITableViewCellAccessoryType.None
            Kelvin.accessoryType = UITableViewCellAccessoryType.None
            
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            
            selectedCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    public func saveButtonPressed(sender: AnyObject) {
        if Fahrenheit.accessoryType == UITableViewCellAccessoryType.Checkmark {
            Settings.setTempUnit(TempUnit.Fahrenheit)
        } else if Kelvin.accessoryType == UITableViewCellAccessoryType.Checkmark {
            Settings.setTempUnit(TempUnit.Kelvin)
        } else {
            Settings.setTempUnit(TempUnit.Celsius)
        }
        
        if let text = CityTextField.text {
            Settings.setCity(text);
        } else {
            Settings.setCity("wuerzburg");
        }
    }
}