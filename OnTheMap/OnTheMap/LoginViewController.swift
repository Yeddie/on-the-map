//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/28/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    
    // Text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Tap recognizer for handling keyboard showing / hiding
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    
    // MARK: View Management
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view UI
        configViewUI()
    }
    
    /* View will appear */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    /* View will disappear */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    

    // MARK: Button Actions
    
    
    /* Login button pressed */
    @IBAction func login(sender: UIButton) {
        RequestManager.sharedInstance().createSession(emailTextField.text, password: passwordTextField.text) { (success, statusCode, error) -> Void in
            if success {
                self.successfulLogin()
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
    
    func successfulLogin() {
        print("Login Successful: \(RequestManager.sharedInstance().sessionID)")
    }
    
    
    func failedLogin(statusCode: Int?, error: NSError?) {
        print("Login Failed: \(statusCode)")

        var alertMessage: String = "Unknown Error"
        if let error = error {
            if error.code == -1009 {
                alertMessage = "No internet connectivity"
            }
        } else if let statusCode = statusCode {
            if statusCode == 403 {
                alertMessage = "Wrong Username or Password"
            }
        }
        
        let alert = UIAlertController(title: "Issue logging in", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}


// MARK: - LoginViewController (UI Config & Show/Hide Keyboard)


/* Code from Udacity class project MyFavoriteMovies */
extension LoginViewController {
    
    func configViewUI() {
        // Set ident on text fields
        setTextFieldIndent(emailTextField)
        setTextFieldIndent(passwordTextField)
        
        // Configure tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    /* Set ident view for text fields */
    private func setTextFieldIndent(textField: UITextField!) {
        let textFieldPadView = UIView(frame: CGRectMake(0,0,15, emailTextField.frame.height))
        
        textField.leftView = textFieldPadView
        textField.leftViewMode = UITextFieldViewMode.Always
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}