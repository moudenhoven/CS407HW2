//
//  AddEventViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/6/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint : NSLayoutConstraint!
    var defaultScrollViewHeightConstraint : CGFloat = 0.0
    
    
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
        
        
        
    }
    
    
    //MARK: - CoreData
    func saveEvent(title: NSString, time: NSString, date: NSDate, notes: NSString) {
        
        
        
        
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
