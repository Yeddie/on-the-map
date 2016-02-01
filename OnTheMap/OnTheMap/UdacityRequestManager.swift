//
//  UdacityRequestManager.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/29/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation


class UdacityRequestManager {

    // MARK: Constants
    struct Constants {
        static let BaseURL = "https://www.udacity.com/api/"
    }
    
    
    // MARK: Methods
    struct Methods {
        static let Session = "session"
        static let Users   = "users"
    }
    

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Udacity  = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // Session Method
        static let Session    = "session"
        static let Account    = "account"
        static let Id         = "id"
        static let Key        = "key"
        static let Expiration = "expiration"
        // Get User Method
        static let User       = "user"
        static let LastName   = "last_name"
        static let FirstName  = "first_name"
    }

    
    // MARK: Requests
    
    
    /* Create user session with username and password */
    class func createSession(username: String?, password: String?, completionHandler: (success: Bool, userId: String?, statusCode: Int?, error: NSError?) -> Void) {
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
        RequestManager.sharedInstance().postRequest(request) { (result, statusCode, error) -> Void in
            if let error = error {
                completionHandler(success: false, userId: nil, statusCode:statusCode, error: error)
            } else {
                // GUARD: Check results contain session information
                guard let result = result else {
                    completionHandler(success: false, userId: nil, statusCode:statusCode, error: nil); return
                }
                
                guard let results = result[JSONResponseKeys.Session] as? [String: String] else {
                    completionHandler(success: false, userId: nil, statusCode:statusCode, error: nil); return
                }
                print("success = \(result)")
                guard let account = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                    completionHandler(success: false, userId: nil, statusCode:statusCode, error: nil); return
                }
                guard let returnedSessionId = results[JSONResponseKeys.Id] else { completionHandler(success: false, userId: nil, statusCode:statusCode, error: nil); return }
                guard let accountId = account[JSONResponseKeys.Key] as? String else { completionHandler(success: false, userId: nil, statusCode:statusCode, error: nil); return }
                
                print("createSession = \(result)")
                
                // Save session id and finish completionHandler
                RequestManager.sharedInstance().sessionID = returnedSessionId
                RequestManager.sharedInstance().accountId = accountId
                completionHandler(success: true, userId: accountId, statusCode:statusCode, error: nil)
            }
        }
    }
    
    /* Get Student Information */
    static func getStudentInformation(accountId: String!, completionHandler:(success: Bool, result: AnyObject?, statusCode: Int?, error: NSError?) -> Void) {
        // Create request
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURL + Methods.Users + "/" + accountId)!)
        
        // Run GET request
        RequestManager.sharedInstance().getRequest(true, request: request) { (result, statusCode, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: result, statusCode: statusCode, error: error)
            } else {
                print("getStudentInformation = \(result)")
                // GUARD: Check results contains result information
                guard let result = result else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                guard let user = result[JSONResponseKeys.User] as? [String: AnyObject] else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                guard let firstName = user[JSONResponseKeys.FirstName] as? String else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                RequestManager.sharedInstance().firstName = firstName
                
                guard let lastName = user[JSONResponseKeys.FirstName] as? String else {
                    completionHandler(success: false, result: nil, statusCode:statusCode, error: nil); return
                }
                
                RequestManager.sharedInstance().lastName = lastName
                
                print("getStudentInformation = \(result)")
                
                completionHandler(success: true, result: user, statusCode:statusCode, error: nil)
            }
        }
    }
    
    /* Logout user of current session */
    class func logoutUser(completionHandler: (success: Bool, statusCode: Int?, error: NSError?) -> Void) {
        // Create request
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURL + Methods.Session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // Run post request
        RequestManager.sharedInstance().postRequest(request) { (result, statusCode, error) -> Void in
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
                
                guard let _ = results[JSONResponseKeys.Id] else { completionHandler(success: false, statusCode:statusCode, error: nil); return }
                
                // Save session id and finish completionHandler
                RequestManager.sharedInstance().sessionID = nil
                completionHandler(success: true, statusCode:statusCode, error: nil)
            }
        }
    }
}