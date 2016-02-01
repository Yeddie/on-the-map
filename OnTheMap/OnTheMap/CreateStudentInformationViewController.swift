//
//  CreateStudentInformationViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/31/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class CreateStudentInformationViewController: BaseViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    let geocoder = CLGeocoder()
    var studentInformation = StudentInformation()
    var addressSuccess = false
    
    // MARK: View Management
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ident on text fields
        MapUtils.setTextFieldIndent(locationTextField)
        submitButton.contentHorizontalAlignment = .Center;
    }
    
    override func viewWillAppear(animated: Bool) {
        if addressSuccess {
            updateUI()
        }
    }
    
    
    // MARK: Action Methods
    
    
    /* Cancel button pressed, dismiss view */
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Submit button pressed */
    @IBAction func submitButtonPressed(sender: UIButton) {
        print("success = \(addressSuccess) - text = \(locationTextField.text)")
        if addressSuccess {
            // Send user's location
            submit(locationTextField.text)
        } else {
            // Get user's location
            createGeocoder(locationTextField.text)
        }
    }
    
    /* Send User's location */
    func submit(url: String!) {
        guard url != nil && url.characters.count > 0 else {
            MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.LocationIssue, message: MapUtils.AlertMessages.InvalidUrl)
            return
        }
        
        studentInformation.mediaURL = url
        
        // Send user information to server
        ParseRequestManager.submitStudentLocation(studentInformation) { (success, statusCode, error) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.NetworkIssue, message: MapUtils.AlertMessages.SubmissionError)
            }
        }
    }
    
    
    // MARK: Map Management
    
    
    /* Create geocoder and zoom map */
    func createGeocoder(address: String!) {
        guard address != nil && address.characters.count > 0 else {
            MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.LocationIssue, message: MapUtils.AlertMessages.NoAddress)
            return
        }

        geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] {
                print(placemark)
                self.addressSuccess = true
                
                // Get lat and long for coordinate
                let latitude = placemark.location!.coordinate.latitude
                let longitude = placemark.location!.coordinate.longitude
                
                // Create coordinate
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                // Create annotation and its information
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                // Clear existing annotations and then add new annotations to map view
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations([annotation])
                
                // Create map rect and zoom to annotation
                let mapPoint = MKMapPointForCoordinate(coordinate)
                let mapRect = MKMapRectMake(mapPoint.x, mapPoint.y, 1.0, 1.0)
                self.mapView.setVisibleMapRect(mapRect, animated: true)
                
                // Update student information
                self.studentInformation.mapString = placemark.name!
                self.studentInformation.latitude = Float(latitude)
                self.studentInformation.longitude = Float(longitude)
                self.studentInformation.firstName = RequestManager.sharedInstance().firstName!
                self.studentInformation.lastName = RequestManager.sharedInstance().lastName!
                self.studentInformation.uniqueKey = RequestManager.sharedInstance().accountId!
                
                // Update UI
                self.updateUI()
            } else {
                MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.LocationIssue, message: MapUtils.AlertMessages.AddressError)
            }
        }
    }
    
    
    // MARK: UI Methods
    
    
    /* Change label and button text */
    func updateUI() {
        self.locationTextField.text = ""
        self.questionLabel.text = "Enter a URL link."
        self.submitButton.setTitle("Submit", forState: .Normal)
    }
}