//
//  StudentInformationDataSource.swift
//  OnTheMap
//
//  Created by Eddie Groberski on 1/30/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation

class StudentInformationDataSource: NSObject {
    
    // MARK: Properties
    
    
    var students : [StudentInformation] = [StudentInformation]()
    
    
    // MARK: Data Management
    
    
    /* Set students with array of StudentInforation */
    func studentInformationFromResults(results: [[String : AnyObject]]) {
        var studentInformation = [StudentInformation]()
        
        for result in results {
            studentInformation.append(StudentInformation(dictionary: result))
        }
        
        students = studentInformation
    }
}