//
//  AddEventViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/6/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit
import CoreData

class AddEventViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!
    var defaultScrollViewHeightConstraint : CGFloat = 0.0
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    //var eventAdded  : NSManagedObject? = NSManagedObject()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //make a copy of the constraint value for when the keyboard closes, can reset the auto layout
        defaultScrollViewHeightConstraint = self.scrollViewHeightConstraint.constant
        
        //add observers to call methods when the keyboard appears or disappears
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //remove the observers from the notification center
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func saveClicked(sender: AnyObject) {
        //use UIActivity indicator view
        

        //save to core  data
        saveEvent()
        
        
    }
    
    
    //MARK: - CoreData
    func saveEvent() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
        
        let event = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        event.setValue(titleField!.text, forKey: "title")
        event.setValue(notesTextView!.text, forKey: "notes")
        event.setValue(datePicker.date, forKey: "date")
        event.setValue(locationField!.text, forKey: "location")
        
        do{
            try managedContext.save()
            
            //self.eventAdded = event
        } catch let error as NSError {
            print("could not save \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    
    //MARK: - Observer Methods
    
    //method to make scroll view function when the keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        //print("keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollViewHeightConstraint.constant += keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification : NSNotification) {
        //print("keyboard will hide")
        //keyboard hiding set scroll view back to regular height
        self.scrollViewHeightConstraint.constant = self.defaultScrollViewHeightConstraint
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("prepare for segue")
    }
    
    
    
    
    func formatDate(date: NSDate) {
        /*
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(datePicker.date)
        print(fullDate)
        
        let delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        let time = dateArray[1]
        let date = dateArray[0]
*/
    }

}
