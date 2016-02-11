//
//  ToolBar.swift
//  Weather
//
//  Created by student on 20.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation
import UIKit

public class SettingsToolBar: UIToolbar, UIToolbarDelegate
{
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition
    {
        return UIBarPosition.TopAttached;
    }
}