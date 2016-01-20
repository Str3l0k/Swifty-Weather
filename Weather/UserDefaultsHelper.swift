//
//  UserDefaultsHelper.swift
//  Weather
//
//  Created by student on 16.01.16.
//  Copyright © 2016 FHWS. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    static func saveUserDefault(key: String, value: String){
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(value, forKey: key)
        
        //synchronize the object - Important don't forget that
        defaults.synchronize()
    }
    static func loadUserDefaults(key: String) -> String? {
        //Load an Object
        //get the standardUserDefaults from the OS
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        return defaults.stringForKey(key)
    }
}