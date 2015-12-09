//
//  CreateEventViewController.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/8/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var hostedBy: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var anythingElse: UITextField!
    
    @IBAction func hostCreateEvent(sender: UIButton) {
        // Create a parse object
        let eventObject = PFObject(className: "Event")
        eventObject["EventName"] = eventName.text
        eventObject["hostedBy"] = hostedBy.text
        eventObject["location"] = location.text
        eventObject["description"] = anythingElse.text
        eventObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        print("Object has been saved.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
