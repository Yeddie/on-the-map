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
    
}