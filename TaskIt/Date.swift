//
//  Date.swift
//  TaskIt
//
//  Created by Luc on 08/11/14.
//  Copyright (c) 2014 lcj. All rights reserved.
//

import Foundation

class Date {
    
    class func from (#year:Int, month: Int, day: Int) -> NSDate {
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)
        var date = gregorianCalendar?.dateFromComponents(components)
        
        return date!
    }
    
    class func toString(#date:NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyy-MM-dd"
        let dateString = dateStringFormatter.stringFromDate(date)
        return dateString
    }
    
}