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
    var start : String
    var end : String
    var location : String
    var description : String
    
    init() {
        objectID = "objectID?"
        eventName = "eventName?"
        hostedBy = "hostedBy?"
        start = "start?"
        end = "end?"
        location = "location?"
        description = "description"
    }
    
}
