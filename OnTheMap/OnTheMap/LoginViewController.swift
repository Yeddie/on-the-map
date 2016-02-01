//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/28/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: Properties
    
    
    // Text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    // MARK: View Management
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ident on text fields
        MapUtils.setTextFieldIndent(emailTextField)
        MapUtils.setTextFieldIndent(passwordTextField)
    }
    
    
    // MARK: Button Actions
    
    
    /* Login button pressed */
    @IBAction func login(sender: UIButton) {
        UdacityRequestManager.createSession(emailTextField.text, password: passwordTextField.text) { (success, userId, statusCode, error) -> Void in
            if success {
                UdacityRequestManager.getStudentInformation(userId, completionHandler: { (success, result, statusCode, error) -> Void in
                    if success {
                        self.successfulLogin()
                    } else {
                        self.failedLogin(statusCode, error: error)
                    }
                })
            } else {
                self.failedLogin(statusCode, error: error)
            }
        }
    }
    
    /* Sign up button pressed */
    @IBAction func signUp(sender: UIButton) {
        // Send user to Udacity's sign up page
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    
    // MARK: Login Managment
    
    
    /* Login was successful */
    func successfulLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            // Clear email and password fields
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            // Present MapTabBarController
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    /* Login was unsuccessful */
    func failedLogin(statusCode: Int?, error: NSError?) {
        print("Login Failed: \(statusCode)")
        
        let alertTitle = MapUtils.AlertTitles.NetworkIssue
        var alertMessage = MapUtils.AlertMessages.UnknowError
        if let error = error {
            if error.code == -1009 {
                alertMessage = MapUtils.AlertMessages.NoInternet
            }
        } else if let statusCode = statusCode {
            if statusCode == 403 {
                alertMessage = MapUtils.AlertMessages.WrongCredientials
            }
        }

        // Show alert
        MapUtils.presentAlertViewController(self, title: alertTitle, message: alertMessage)
    }
}