//
//  CreateEventViewController.swift
//  DGCalendarTutorial
//
//  Created by Jennifer Han on 12/8/15.
//  Copyright © 2015 Jennifer Han. All rights reserved.
//

import UIKit
import Parse

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var hostedBy: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var anythingElse: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    var dateFormatter = NSDateFormatter()
    
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
        // Create a parse object
        let eventObject = PFObject(className: "Event")
        
        // all string attributes
        eventObject["EventName"] = eventName.text
        eventObject["hostedBy"] = hostedBy.text
        eventObject["location"] = location.text
        eventObject["description"] = anythingElse.text
        
        // saving the photo file
        let photo = imageView.image!
        let eventImageData = UIImagePNGRepresentation(photo)
        let file = PFFile(name: eventName.text! + "Photo.png", data: eventImageData!)
        file!.saveInBackground()
        eventObject["eventPhoto"] = file
        
        // save the start time and end time
        let startNSDate = dateFormatter.dateFromString(startTextField.text!)
        let endNSDate = dateFormatter.dateFromString(endTextField.text!)
        eventObject["start"] = startNSDate
        eventObject["end"] = endNSDate
        
        
        eventObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        print("Object has been saved.")
        }
        
        let alertController = UIAlertController(title: "Event has been posted!", message: "Your created event will be seen by Grapevine users.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
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
