//
//  MapListTableViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/28/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import UIKit

class MapListTableViewController: UITableViewController {
    
    // MARK: Properities
    
    
    let dataSource = StudentInformationDataSource()

    
    // MARK: View Management
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* View will appear */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data source
        loadDataSource()
    }
    
    
    // MARK: StudentInformationDataSource Management
    
    
    /* Load student data records */
    func loadDataSource() {
        ParseRequestManager.getStudentLocations { (success, result, statusCode, error) -> Void in
            if success {
                if let results = result as? [[String: AnyObject]] {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dataSource.studentInformationFromResults(results)
                        self.tableView.reloadData()
                    }
                }
            } else {
                // There was an issue with the webservice so we display pop up
                let alert = UIAlertController(title: "Network Issue", message: "Could not download student records", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue()) {
                    // Present AlertViewController
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

