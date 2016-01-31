//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/30/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit


struct StudentInformation {
    
    // MARK: Properties
    
    
    var objectId           = ""
    var uniqueKey: String? = nil
    var firstName          = ""
    var lastName           = ""
    var mapString          = ""
    var mediaURL           = ""
    var latitude: Float    = 0.0
    var longitude: Float   = 0.0
    var createdAt          = ""
    var updatedAt          = ""
    
    
    // MARK: Initializers
    
    
    /* Construct a StudentInformation from a dictionary */
    init(dictionary: [String : AnyObject]) {
        objectId  = dictionary[ParseRequestManager.JSONResponseKeys.ObjectId]  as! String
        uniqueKey = dictionary[ParseRequestManager.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseRequestManager.JSONResponseKeys.FirstName] as! String
        lastName  = dictionary[ParseRequestManager.JSONResponseKeys.LastName]  as! String
        mapString = dictionary[ParseRequestManager.JSONResponseKeys.MapString] as! String
        mediaURL  = dictionary[ParseRequestManager.JSONResponseKeys.MediaURL]  as! String
        latitude  = dictionary[ParseRequestManager.JSONResponseKeys.Latitude]  as! Float
        longitude = dictionary[ParseRequestManager.JSONResponseKeys.Longitude] as! Float
        createdAt = dictionary[ParseRequestManager.JSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseRequestManager.JSONResponseKeys.UpdatedAt] as! String
    }
    
    
    // MARK: Helpers
    
    
    /* Return full name with combination of first and last name */
    func fullName() -> String {
        return firstName + " " + lastName
    }
}