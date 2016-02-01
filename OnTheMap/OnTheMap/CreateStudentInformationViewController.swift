//
//  CreateStudentInformationViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/31/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit


class CreateStudentInformationViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    // MARK: View Management
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ident on text fields
        MapUtils.setTextFieldIndent(locationTextField)
    }
    
    
    // MARK: Action Methods
    
    
    /* Cancel button pressed, dismiss view */
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Submit button pressed */
    @IBAction func submitButtonPressed(sender: UIButton) {
    }
}