//
//  MapUtils.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/30/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class MapUtils {
    
    // MARK: Alert Title
    struct AlertTitles {
        static let NetworkIssue  = "Network Issue"
    }
    
    
    // MARK: Alert Messages
    struct AlertMessages {
        static let UnknowError            = "Unknown Error"
        static let NoInternet             = "No internet connectivity"
        static let WrongCredientials      = "Wrong Username or Password"
        static let CouldNotDowloadRecords = "Could not download student records"
        static let InvalidUrl             = "Invalid URL"
        static let LogOutError            = "Could not log user out"
    }
    
    
    // MARK: Alert Methods
    
    
    /* Create and present alert with given viewController, title, and message */
    class func presentAlertViewController(viewController: UIViewController!, title: String!, message: String!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
            // Present AlertViewController
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: URL Methods
    
    
    /* Check if given url is valid and open safari */
    class func openUrlIfValid(url: String!, viewController: UIViewController!) {
        if let url = NSURL(string: url) {
            
            // Attempt to open url
            let canOpenUrl = UIApplication.sharedApplication().canOpenURL(url)
            
            if canOpenUrl {
                // Open safari with link
                UIApplication.sharedApplication().openURL(url)
            } else {
                // Present Alert - URL invalid
                MapUtils.presentAlertViewController(viewController, title: MapUtils.AlertTitles.NetworkIssue, message: MapUtils.AlertMessages.InvalidUrl)
            }
        }
    }
}