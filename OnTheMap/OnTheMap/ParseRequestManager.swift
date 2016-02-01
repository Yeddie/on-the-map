//
//  ParseRequestManager.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/30/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation

class ParseRequestManager {
    
    // MARK: Constants
    struct Constants {
        static let BaseURL    = "https://api.parse.com/1/classes/StudentLocation"
        static let ParseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let Limit      = 100
        static let Order      = "-updatedAt"
    }
    
    
    // MARK: Methods
    struct Methods {

    }
    
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ParseAppId = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
        static let Limit      = "limit"
        static let Order      = "-order"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // GET StudentLocations
        static let Results   = "results"
        static let ObjectId  = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName  = "lastName"
        static let MapString = "mapString"
        static let MediaURL  = "mediaURL"
        static let Latitude  = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
    
    // MARK: GET Request
    
    
    /* Get Student Locations */
    static func getStudentLocations(completionHandler:(success: Bool, result: AnyObject?, statusCode: Int?, error: NSError?) -> Void) {
        // Set limi and order parameter
        let parameters: [String : AnyObject] = [ParameterKeys.Limit: Constants.Limit, ParameterKeys.Order: Constants.Order]
        let url = NSURL(string: Constants.BaseURL + RequestManager.escapedParameters(parameters))!
        let request = createParseRequest(url)
        
        // Run GET request
        RequestManager.sharedInstance().getRequest(false, request: request) { (result, statusCode, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: result, statusCode: statusCode, error: error)
            } else {
                // GUARD: Check results contains result information
                guard let result = result else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                guard let results = result[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                print("(getStudentLocations) - Result: \(result)")
                completionHandler(success: true, result: results, statusCode:statusCode, error: nil)
            }
        }
    }
    
    
    // MARK: Post Request
    
    
    /* Create user session with username and password */
    class func submitStudentLocation(studentInformation: StudentInformation!, completionHandler: (success: Bool, statusCode: Int?, error: NSError?) -> Void) {
        // Create request
        let request = createParseRequest(NSURL(string: Constants.BaseURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create parameters and add to HTTPBody
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(studentInformation.dictionaryOfStudentInformation(), options: .PrettyPrinted)
        }
        
        // Run post request
        RequestManager.sharedInstance().postRequest(false, request: request) { (result, statusCode, error) -> Void in
            if let error = error {
                completionHandler(success: false, statusCode:statusCode, error: error)
            } else {
                // GUARD: Check results contain session information
                guard let result = result else {
                    completionHandler(success: false, statusCode:statusCode, error: nil); return
                }
                
                print("submitStudentLocation = \(result)")

                completionHandler(success: true, statusCode:statusCode, error: nil)
            }
        }
    }
    
    
    //MARK: Helper methods
    
    
    /* Helper: Create mututable URL request for Parse requst */
    static private func createParseRequest(url: NSURL) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseAppId, forHTTPHeaderField: ParameterKeys.ParseAppId)
        request.addValue(Constants.RestApiKey, forHTTPHeaderField: ParameterKeys.RestApiKey)
        return request
    }
}