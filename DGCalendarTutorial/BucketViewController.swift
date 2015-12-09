//
//  BucketViewController.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/8/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import UIKit
import Parse

class BucketViewController: UIViewController {
    
    var bucketEventsArray: [Event] = []
    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getBucketEventsDataFromParse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBucketEventsDataFromParse() {
        let bucketEventIDsQuery = PFQuery(className: "UserEvent")
        bucketEventIDsQuery.whereKey("category", equalTo: "bucket")
        //let user = PFUser.currentUser()
        let user = "J98yoB5TDH"
        bucketEventIDsQuery.whereKey("userID", equalTo: user)
        
        bucketEventIDsQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) eventIDs.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        // add this objectID to the bucketEventIDsArray
                        let id = object["eventID"] as! String
                        self.getEventWithID(id)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getEventWithID(id: String) {
        let getEventQuery = PFQuery(className: "Event")
        getEventQuery.getObjectInBackgroundWithId(id) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                if let event = object {
                    let newEvent = Event()
                    
                    newEvent.objectID = event.objectId!
                    newEvent.eventName = event["EventName"] as! String
                    newEvent.location = event["location"] as! String
                    newEvent.hostedBy = event["hostedBy"] as! String
                    newEvent.start = event["start"] as! NSDate
                    newEvent.end = event["end"] as! NSDate
                    newEvent.description = event["description"] as! String
                    
                    // add this new Event object to the bucketEventsArray
                    print(newEvent.eventName)
                    self.bucketEventsArray.append(newEvent)
                }
            } else {
                print(error)
            }
        }
    }
    

    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

