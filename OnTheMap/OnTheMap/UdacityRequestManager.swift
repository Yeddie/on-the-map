//
//  UdacityRequestManager.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/29/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation


extension RequestManager {
    
    // MARK: Constants
    struct Constants {
        static let BaseURL : String = "https://www.udacity.com/api/"
    }
    
    
    // MARK: Methods
    struct Methods {
        static let Session = "session"
    }
    

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // Session Method
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
    }

    
    // MARK: Requests
    
    
    /* Create user session with username and password */
    func createSession(username: String?, password: String?, completionHandler: (success: Bool, statusCode: Int?, error: NSError?) -> Void) {
        // GUARD: Username and password are not nil
        guard username != nil && username?.characters.count > 0 else { print("(createSession) - username is empty"); return }
        guard password != nil && password?.characters.count > 0 else { print("(createSession) - password is empty"); return }
        
        // Create request
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURL + Methods.Session)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create parameters and add to HTTPBody
        do {
            let parameters: [String: AnyObject] = [ParameterKeys.Udacity: [ParameterKeys.Username: username!, ParameterKeys.Password: password!]]
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
        }
        
        // Run post request
        postRequest(request) { (result, statusCode, error) -> Void in
            if let error = error {
                completionHandler(success: false, statusCode:statusCode, error: error)
            } else {
                // GUARD: Check results contain session information
                guard let result = result else {
                    completionHandler(success: false, statusCode:statusCode, error: nil); return
                }
                
                guard let results = result[JSONResponseKeys.Session] as? [String: String] else {
                    completionHandler(success: false, statusCode:statusCode, error: nil); return
                }
                
                guard let returnedSessionId = results[JSONResponseKeys.Id] else { completionHandler(success: false, statusCode:statusCode, error: nil); return }
                
                // Save session id and finish completionHandler
                self.sessionID = returnedSessionId
                completionHandler(success: true, statusCode:statusCode, error: nil)
            }
        }
    }
}