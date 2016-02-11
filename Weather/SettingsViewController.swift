//
//  SettingsViewController.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

public class SettingsViewController: UIViewController, UIToolbarDelegate, SendReloadViewController
{
    var childViewController:      SettingsTableViewController?
    var reloadableViewController: ReloadViewController?
    @IBOutlet weak var toolbar: UIToolbar!

    public override func viewDidLoad()
    {
        toolbar.delegate = self
    }

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        guard let childViewController = childViewController else {
            return;
        }
        childViewController.saveButtonPressed(sender)
        if let reload = reloadableViewController
        {
            reload.reload()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segName = segue.identifier
        if segName == "SettingsTableViewControllerSegue"
        {
            childViewController = segue.destinationViewController as? SettingsTableViewController
        }
    }

    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition
    {
        return UIBarPosition.TopAttached
    }

    func setReloadViewController(controller: ReloadViewController)
    {
        reloadableViewController = controller
    }
}

