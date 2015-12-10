//
//  CreateEventViewController.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/8/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var hostedBy: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var anythingElse: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
        
    let imagePicker = UIImagePickerController()
    var dateFormatter = NSDateFormatter()
    // keyboard height
    var kbHeight: CGFloat!
    
    @IBAction func addImageButtonTapped() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func startTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("startPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func endTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("endPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    
    @IBAction func hostCreateEvent(sender: UIButton) {
        // Save to the Events table first
        // Create a parse object
        let eventObject = PFObject(className: "Event")
        
        // all string attributes
        eventObject["EventName"] = eventName.text
        eventObject["hostedBy"] = hostedBy.text
        eventObject["location"] = location.text
        eventObject["description"] = anythingElse.text
        
        // saving the photo file
        let photo = imageView.image!
        let eventImageData = UIImageJPEGRepresentation(photo, 0.5)
        let file = PFFile(name: eventName.text! + "Photo.png", data: eventImageData!)
        file!.saveInBackground()
        eventObject["eventPhoto"] = file
    
        // save the start time and end time
        let startNSDate = dateFormatter.dateFromString(startTextField.text!)
        let endNSDate = dateFormatter.dateFromString(endTextField.text!)
        eventObject["start"] = startNSDate
        eventObject["end"] = endNSDate
        
        do {
            try eventObject.save()
        } catch {
            print(error)
        }
        
        // This isn't fully working yet, async request is giving issues
        // Then save to the UserEvent table to denote the relationship between the user and event as category "host"
        //let user = PFUser.currentUser()
        let user = "J98yoB5TDH"
        let userEventObject = PFObject(className: "UserEvent")
        userEventObject["category"] = "host"
        userEventObject["in_calendar"] = false
        userEventObject["userID"] = user
        userEventObject["eventID"] = eventObject.objectId
        userEventObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("UserEvent Object has been saved.")
        }

//        eventObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("New Event object has been saved.")
//        }
        
 
        let alertController = UIAlertController(title: "Event has been posted!", message: "Your created event will be seen by Grapevine users.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { action in self.performSegueWithIdentifier("hostCreateEvent", sender: self) } )
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        eventName.delegate = self
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startPickerValueChanged(sender:UIDatePicker) {
        startTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func endPickerValueChanged(sender:UIDatePicker) {
        endTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // All functions for dismissing the keyboard when creating in a form
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Delegate method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
 
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
