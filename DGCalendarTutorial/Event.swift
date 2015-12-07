//
//  Event.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/6/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import Foundation
import Parse

class Event {
    
    var objectID : String
    var eventName : String
    var hostedBy : String
    var start : NSDate
    var end : NSDate
    var location : String
    var description : String
    
    init() {
        objectID = "objectID?"
        eventName = "eventName?"
        hostedBy = "hostedBy?"
        start = NSDate()
        end = NSDate()
        location = "location?"
        description = "description"
    }
    
}
