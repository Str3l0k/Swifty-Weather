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
    
    public override func viewDidLoad() {
        if let city = Settings.getCity(){
            CityTextField.text = city;
        }
        if Settings.getTempUnit() == TempUnit.Fahrenheit{
            Fahrenheit.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else {
            Celsius.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Fahrenheit.accessoryType = UITableViewCellAccessoryType.None
        Celsius.accessoryType = UITableViewCellAccessoryType.None
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                Fahrenheit.accessoryType = UITableViewCellAccessoryType.Checkmark
                Settings.setTempUnit(TempUnit.Fahrenheit)
                
            }else if(indexPath.row == 1){
                Celsius.accessoryType = UITableViewCellAccessoryType.Checkmark
                Settings.setTempUnit(TempUnit.Celsius)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    public func saveButtonPressed(sender: AnyObject) {
        if Fahrenheit.accessoryType == UITableViewCellAccessoryType.Checkmark {
            Settings.setTempUnit(TempUnit.Fahrenheit)
        }else{
            Settings.setTempUnit(TempUnit.Celsius)
        }
        if let text = CityTextField.text{
            Settings.setCity(text);
        }else{
            Settings.setCity("wuerzburg");
        }
        
    }
}