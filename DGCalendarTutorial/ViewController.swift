//
//  ViewController.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/4/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import UIKit
import EventKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var savedEventId : String = ""
    var arrayIndex : Int = 0
    var eventsArray: [Event] = []
    var dateFormatter = NSDateFormatter()

    // IBActions
    @IBAction func nextButtonClicked() {
        arrayIndex++;
        displayEvent()
    }
    
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
    @IBAction func addEvent(sender: UIButton) {
        let eventStore = EKEventStore()

        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: self.eventsArray[self.arrayIndex].eventName, startDate: self.eventsArray[self.arrayIndex].start, endDate: self.eventsArray[self.arrayIndex].end)
            })
        } else {
            self.createEvent(eventStore, title: self.eventsArray[self.arrayIndex].eventName, startDate: self.eventsArray[arrayIndex].start, endDate: self.eventsArray[arrayIndex].end)
        }
    }
    

    override func viewDidLoad() {
        print("got here")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // sets the display date format for the dateformatter, used for all dates with the stringFromDate method
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
        getEventsDataFromParse()
        
        //        // Testing parse set up
        //        let testObject = PFObject(className: "Event")
        //        testObject["EventName"] = "End Of Finals"
        //        testObject["hostedBy"] = "The Students of CMU"
        //        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        //            print("Object has been saved.")
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        print(event.startDate)
        print(event.endDate)
        
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
        
        
        let alertController = UIAlertController(title: "Event Saved!", message: "Your event has been saved to your iCalendar.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func getEventsDataFromParse() {
        var query = PFQuery(className:"Event")
        //query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let newEvent = Event()
                        
                        newEvent.objectID = object.objectId!
                        newEvent.eventName = object["EventName"] as! String
                        newEvent.location = object["location"] as! String
                        newEvent.hostedBy = object["hostedBy"] as! String
                        newEvent.start = object["start"] as! NSDate
                        newEvent.end = object["end"] as! NSDate
                        newEvent.description = object["description"] as! String
                        
                        // add this new Event object to the eventsArray
                        self.eventsArray.append(newEvent)

                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.displayEvent()
        }
        

    }
    
    
    func displayEvent() {
        if (arrayIndex < self.eventsArray.count) {
            eventNameLabel.text = self.eventsArray[arrayIndex].eventName
            hostedByLabel.text = self.eventsArray[arrayIndex].hostedBy
            startLabel.text = dateFormatter.stringFromDate(self.eventsArray[arrayIndex].start)
            locationLabel.text = self.eventsArray[arrayIndex].location
            descriptionLabel.text = self.eventsArray[arrayIndex].description
        } else {
            let alertController = UIAlertController(title: "No more events to display", message: "There are no more events. Check back in a few hours for more!", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    // Probably functions that are not needed for Grapevine
    //    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    //    // accessible
    //    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
    //        let eventToRemove = eventStore.eventWithIdentifier(eventIdentifier)
    //        if (eventToRemove != nil) {
    //            do {
    //                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
    //            } catch {
    //                print("Bad things happened")
    //            }
    //        }
    //    }
    
    //    // Responds to button to remove event. This checks that we have permission first, before removing the
    //    // event
    //    @IBAction func removeEvent(sender: UIButton) {
    //        let eventStore = EKEventStore()
    //
    //        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
    //            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
    //                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
    //            })
    //        } else {
    //            deleteEvent(eventStore, eventIdentifier: savedEventId)
    //        }
    //        
    //    }
    
    
    
    // may not be necessary
    //    // converts a NSDate object from GMT to EST (subtract 5 hours, 18000 seconds)
    //    func convertToEST(date: NSDate) -> NSDate {
    //        print(date)
    //        let newDate = date.dateByAddingTimeInterval(-18000)
    //        print(newDate)
    //        return newDate
    //    }
}

