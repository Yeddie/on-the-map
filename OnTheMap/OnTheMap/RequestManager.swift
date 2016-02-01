//
//  RequestManager.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/29/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit


// MARK: - RequestManager: NSObject


class RequestManager : NSObject {
    
    // MARK: Properties
    var session: NSURLSession
    var sessionID: String? = nil
    var accountId: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    
    // MARK: Initializers
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    

    // MARK: POST request
    
    
    /* Run POST request */
    func postRequest(request: NSURLRequest, completionHandler: (result: AnyObject!, statusCode: Int?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // GUARD: Check if there was an error
            guard (error == nil) else { completionHandler(result: data, statusCode: 0, error: error); print("Request - Error: \(error)"); return }
            
            // GUARD: Check if data was returned
            guard let data = data else { print("Request - No Data"); return }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: data, statusCode: response.statusCode, error: error)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // Skip 5 characters from Udacity response
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // Parse data and send to completion handler
            RequestManager.parseJSONWithCompletionHandler(newData, statusCode: statusCode, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    
    // MARK: GET request
    
    
    /* Run GET request */
    func getRequest(trimData: Bool, request: NSURLRequest, completionHandler: (result: AnyObject!, statusCode: Int?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // Make request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // GUARD: Check if there was an error
            guard (error == nil) else { completionHandler(result: data, statusCode: 0, error: error); print("Request - Error: \(error)"); return }
            
            // GUARD: Check if data was returned
            guard var data = data else { print("Request - No Data"); return }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: data, statusCode: response.statusCode, error: error)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // Skip 5 characters from Udacity response
            if trimData {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            }
            
            // Parse data and send to completion handler
            RequestManager.parseJSONWithCompletionHandler(data, statusCode: statusCode, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    
    
    // MARK: Helpers
    
    
    /* Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, statusCode: Int?, completionHandler: (result: AnyObject!, statusCode: Int?, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, statusCode: statusCode, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, statusCode: statusCode, error: nil)
    }
    
    /* Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            // Make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    // MARK: Shared Instance
    
    
    /* Singleton shared instance of RequestManager */
    class func sharedInstance() -> RequestManager {
        
        struct Singleton {
            static var sharedInstance = RequestManager()
        }
        
        return Singleton.sharedInstance
    }
}