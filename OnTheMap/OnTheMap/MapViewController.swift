//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/28/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class MapViewController: UIViewController {

    // MARK: Properties 

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: View Management
    
    
    /* View did load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set mapView delegate
        mapView.delegate = self
    }
    
    /* View will appear, load data source */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data source and annotations
        loadDataSource()
    }
    
    
    // MARK: Data Manangement
    

    /* Load student data records */
    func loadDataSource() {
        ParseRequestManager.getStudentLocations { (success, result, statusCode, error) -> Void in
            if success {
                if let results = result as? [[String: AnyObject]] {
                    dispatch_async(dispatch_get_main_queue()) {
                        let dataSource = StudentInformationDataSource()
                        dataSource.studentInformationFromResults(results)
                        
                        // Create annotations
                        self.createAnnotations(dataSource.students)
                    }
                }
            } else {
                // There was an issue with the webservice so we display alert
                MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.NetworkIssue, message: MapUtils.AlertMessages.CouldNotDowloadRecords)
            }
        }
    }
    
    /* Create annotations for map view */
    func createAnnotations(students: [StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            // Lat and long of the student
            let latitude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            
            // Create coordinate
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Create annotation and its information
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.fullName()
            annotation.subtitle = student.mediaURL
            
            // Add annotations to list
            annotations.append(annotation)
        }
        
        // Clear existing annotations and then add new annotations to map view
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    
    // MARK: Button Actions
    
    
    /* Refresh button pressed, reload data */
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        loadDataSource()
    }
    
    /* Add pin button pressed, create new pin */
    @IBAction func addPinButtonPressed(sender: UIBarButtonItem) {
    }
    
    /* Logout button pressed, log user out */
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        UdacityRequestManager.logoutUser { (success, statusCode, error) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                MapUtils.presentAlertViewController(self, title: MapUtils.AlertTitles.NetworkIssue, message: MapUtils.AlertMessages.LogOutError)
            }
        }
    }
}


// MARK: MapViewController - MKMapViewDelegate


extension MapViewController: MKMapViewDelegate {

    
    /* Returns the view associated with the specified annotation object. */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Get pin view
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            // Create pin view
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    /* Tells the delegate that the user tapped one of the annotation view’s accessory buttons. */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle! {
                // Check if valid url and open safari
                MapUtils.openUrlIfValid(url, viewController: self)
            }
        }
    }
}

