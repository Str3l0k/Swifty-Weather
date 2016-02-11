//
//  SettingsViewController.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

public class SettingsViewController: UIViewController
{
    var childViewController:      SettingsTableViewController?
    var reloadableViewController: ReloadViewControllerProtocol?

    @IBOutlet weak var toolbar: UIToolbar!

    // MARK: - overwritten functions
    public override func viewDidLoad()
    {
        toolbar.delegate = self
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segName = segue.identifier

        if segName == "SettingsTableViewControllerSegue"
        {
            childViewController = segue.destinationViewController as? SettingsTableViewController
        }
    }

    // MARK: - IBActions
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
}

// MARK: - UIToolbarDelegate

extension SettingsViewController: UIToolbarDelegate
{
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition
    {
        return UIBarPosition.TopAttached
    }
}

// MARK: - SendReloadViewControllerProtocol

extension SettingsViewController: SendReloadViewControllerProtocol
{
    func setReloadViewController(controller: ReloadViewControllerProtocol)
    {
        reloadableViewController = controller
    }
}

