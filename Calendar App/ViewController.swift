//
//  ViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit
import CVCalendar


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    //MARK: - Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var monthLabel: UINavigationItem!
    @IBOutlet weak var nextMonthButton: UIBarButtonItem!
    @IBOutlet weak var prevMonthButton: UIBarButtonItem!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var swipeRight : UISwipeGestureRecognizer?
    var swipeLeft : UISwipeGestureRecognizer?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        monthLabel.title = CVDate(date: NSDate()).globalDescription
        
        //initialize gesture recognizer for month changes
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("loadNextMonth:"))
        swipeRight!.direction = .Right
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("loadPrevMonth:"))
        swipeLeft!.direction = .Left
        
        //make the navigation bar items work to toggle between months
        nextMonthButton.target = self
        nextMonthButton.action = Selector("loadNextMonth")
        prevMonthButton.target = self
        prevMonthButton.action = Selector("loadPrevMonth")

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //show the old days from the previous and next month
        calendarView.changeDaysOutShowingState(false)
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //laod the next month on a swipe right
    func loadNextMonth() {
        calendarView.loadNextView()
        monthLabel.title = CVDate(date: NSDate()).globalDescription
    }
    
    //load the previous month on a left swipe
    func loadPrevMonth() {
        calendarView.loadPreviousView()
        monthLabel.title = CVDate(date: NSDate()).globalDescription
    }
    
    
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Event")
        
        //let person  = people[indexPath.row]
        
        //cell!.textLabel!.text = person.valueForKey("name") as? String
        
        return cell!
    }


    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.navigationController?.performSegueWithIdentifier("toEventDetailViewController", sender: self)
    }
    
    
    //MARK: - Calendar Delegate Methods
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    //updates the label to tell what month you are currently on
    func presentedDateUpdated(date: Date) {
        //print("presented Date updated")
        monthLabel.title = date.globalDescription
    }
    
    
    

    @IBAction func goToEventDetail(sender: AnyObject) {
        self.performSegueWithIdentifier("toEventDetailViewController", sender: self)
    }

    
}



