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
    
    // Text fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: View Management
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ident on text fields
        setTextFieldIndent(emailTextField)
        setTextFieldIndent(passwordTextField)
    }
    
    
    /* Set ident view for text fields */
    private func setTextFieldIndent(textField: UITextField!) {
        let textFieldPadView = UIView(frame: CGRectMake(0,0,15, emailTextField.frame.height))
        
        textField.leftView = textFieldPadView
        textField.leftViewMode = UITextFieldViewMode.Always
    }
    
    
    // MARK: Button Actions
    
    
    /* Login button pressed */
    @IBAction func login(sender: UIButton) {
        //TODO: Login
    }
    
    
    /* Sign up button pressed */
    @IBAction func signUp(sender: UIButton) {
        // Send user to Udacity's sign up page
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
}
