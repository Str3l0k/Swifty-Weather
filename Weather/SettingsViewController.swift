//
//  SettingsViewController.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

public class SettingsViewController : UIViewController, UIToolbarDelegate {
    var childViewController:SettingsTableViewController? = nil;
    
    @IBOutlet weak var toolbar: UIToolbar!
    public override func viewDidLoad() {
        toolbar.delegate = self
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        guard childViewController != nil else{
            return;
        }
        childViewController!.saveButtonPressed(sender);
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segName = segue.identifier
        if segName == "SettingsTableViewControllerSegue"{
            childViewController = segue.destinationViewController as? SettingsTableViewController
        }
    }
    
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
}

