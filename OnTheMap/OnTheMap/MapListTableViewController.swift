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
                // There was an issue with the webservice so we display alert
                MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.NetworkIssue, message: MapUtils.AlertMessages.CouldNotDowloadRecords)
            }
        }
    }
    
    /* Student Information at given index path */
    private func studentInformationAtIndexPath(indexPath: NSIndexPath) -> StudentInformation {
        return dataSource.students[indexPath.row]
    }
    
    
    // MARK: UITable View Delegate
    
    
    /* Count of datasource students */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.students.count
    }
    
    /* Cell for index path with StudentInformation record  information */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get cell
        let cellReuseIdentifier = "studentReuseId"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // Set cell information
        let studentInformation = studentInformationAtIndexPath(indexPath)
        cell.textLabel!.text = studentInformation.fullName()
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    /* Cell selected, try to open safari with link */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect the row to get rid of highlist
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Get StudentInformation for row
        let studentInformation = studentInformationAtIndexPath(indexPath)
        
        // Check if valid url and open safari
        MapUtils.openUrlIfValid(studentInformation.mediaURL, viewController: self)
    }
    
    
    // MARK: Button Actions
    
    
    /* Refresh button pressed, reload data */
    @IBAction func refreshButtonPushed(sender: UIBarButtonItem) {
        loadDataSource()
    }
    
    /* Add pin button pressed, create new pin */
    @IBAction func addPinButtonPressed(sender: UIBarButtonItem) {
    }
    
    /* Logout button pressed, log user out */
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
    }
}

