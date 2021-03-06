//
//  ViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    //MARK: - Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var monthLabel: UINavigationItem!
    @IBOutlet weak var nextMonthButton: UIBarButtonItem!
    @IBOutlet weak var prevMonthButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var swipeRight : UISwipeGestureRecognizer?
    var swipeLeft : UISwipeGestureRecognizer?
    
    //the current events for the day that is clicked on
    var events = [NSManagedObject]()
    
    //dictionary holding all of the events for the calendar - year as the key, and month then day for the 2D array
    //var eventsDictionary : NSDictionary = [2016: Array<Array<NSManagedObject>>()]
    var eventsDictonary : [String : [String : [String : Array<NSManagedObject>]]] = ["16" : ["1" : ["5" : [NSManagedObject]()]]]
    
    //array of event objects (unsorted) returned when finding the persisting data
    var savedEvents : [NSManagedObject] = []
    
    var firstLoad = true
    
    
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
    
    override func viewWillAppear(animated: Bool) {
        //print("view will appear")
        calendarView.hidden = false
        
        
        //fetching events from core data each time the view appears to display on the table view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Event")
        
        
        
        do{
            //get the results fromt the fetch
            let results = try managedContext.executeFetchRequest(fetchRequest)
            //save the array of results as the events
            events = results as! [NSManagedObject]
            
            savedEvents = results as! [NSManagedObject]
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //load the dictionary of events into the correct format
        loadDictionary()
        
        //reload the table view after the new data is fetched
        tableView.reloadData()
    }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
        
        //show the old days from the previous and next month
        calendarView.changeDaysOutShowingState(false)
        
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
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Event") as! EventTableViewCell
        
        let event  = events[indexPath.row]
        
        let date = event.valueForKey("date") as? NSDate
        
        cell.eventTitleLabel.text = event.valueForKey("title") as? String
        cell.eventTimeLabel.text = timeFromDate(date!)
        
        return cell
    }


    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //send the event with the segue
        //print(indexPath.row)
        
        //get the event that the user clicked on and send it with the segue
        let toSend = events[indexPath.row]
        self.performSegueWithIdentifier("toEventDetailViewController", sender: toSend)
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
    
    //method called when a day is clicked on
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        //print("selected a day!")
        
        let month = String(dayView.date.month)
        let day = String(dayView.date.day)
        
        let temp = String(dayView.date.year)
        //let year = temp.substringFromIndex(2)
        let x = temp.startIndex.advancedBy(2)..<temp.endIndex
        let year = temp[x]
        
        //print(dayView.date.month)
        //print(dayView.date.day)
        //print(dayView.date.year)
        
        //update table view to new events
        if eventsDictonary[year]?[month]?[day] != nil {
            events = (eventsDictonary[year]?[month]?[day])!
        }
        //no events, empty array
        else {
            events = []
        }
        
        //reload the table
        tableView.reloadData()
    }
    

    
    //MARK: - IBActions

    /*
    //method used until full functionality was implemented
    @IBAction func goToEventDetail(sender: AnyObject) {
        self.performSegueWithIdentifier("toEventDetailViewController", sender: self)
    }
    */
    
    //MARK: - Navigation    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toEventDetailViewController" {
            //pass event object here
            let destVC = segue.destinationViewController as! EventDetailViewController
            let event = sender as? NSManagedObject
            
            let date = event?.valueForKey("date") as? NSDate
            
            //print(timeFromDate(date!))
           // print(fullDateFromDate(date!))
            
            //print(event?.valueForKey("title") as? String)
            let title = event?.valueForKey("title") as? String
            let time = timeFromDate(date!)
            let fullDate = fullDateFromDate(date!)
            let notes = event?.valueForKey("notes") as? String
            
            
            //give all of the information to display to the detail view controller
            destVC.labelTitle = title!
            destVC.time = time
            destVC.fullDate = fullDate
            destVC.notes = notes!
            
            //give destVC the event object in case the user deletes it
            destVC.event = event!
            
        }
    }

    //MARK: - Date Conversions
    func timeFromDate(date: NSDate) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(date)
        //print(fullDate)
        
        let delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        let time = dateArray[1]
        //let date = dateArray[0]

        return time
        
    }
    
    func fullDateFromDate(date: NSDate) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(date)
        //print(fullDate)
        
        let delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        //let time = dateArray[1]
        let date = dateArray[0]
        
        return date
        
    }
    
    func monthFromDate(date: NSDate) -> Int {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(date)
        //print(fullDate)
        
        var delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        //let time = dateArray[1]
        let date = dateArray[0]
        
        delimiter = "/"
        let dateSplit = date.componentsSeparatedByString(delimiter)
        
        //first number in the string is the date
        let month = Int(dateSplit[0])
        return month!
        
    }
    
    func dayFromDate(date: NSDate) -> Int {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(date)
        //print(fullDate)
        
        var delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        //let time = dateArray[1]
        let date = dateArray[0]
        
        delimiter = "/"
        let dateSplit = date.componentsSeparatedByString(delimiter)
        
        let day = Int(dateSplit[1])
        return day!
        
    }
    
    func yearFromDate(date: NSDate) -> Int {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let fullDate = formatter.stringFromDate(date)
        //print(fullDate)
        
        var delimiter = ", "
        let dateArray = fullDate.componentsSeparatedByString(delimiter)
        //let time = dateArray[1]
        let date = dateArray[0]
        
        delimiter = "/"
        let dateSplit = date.componentsSeparatedByString(delimiter)
        
        let year = Int(dateSplit[2])
        return year!
        
    }
    
    
    
    //MARK: - Event Handling
    
    //method to load the dictionary with the events into the right spots
    func loadDictionary(){
        //clear the events dictionary so that it can be resorted
        eventsDictonary = ["16" : ["1" : ["5" : [NSManagedObject]()]]]
        
        //loop through the saved events and get their year
        for event in savedEvents {
            let eventDate = event.valueForKey("date") as! NSDate
            let year = String(yearFromDate(eventDate))
            let eventMonth = monthFromDate(eventDate)
            let month = String(eventMonth)
            let eventDay = String(dayFromDate(eventDate))
            
            //check if that year is currently in the dictionary
            if eventsDictonary[year] != nil {
                //year currently in the dictionary
                
                //check if the month is in the year
                if eventsDictonary[year]?[month] != nil {
                    //month is in the year, check if the day alreay has an event
                    if eventsDictonary[year]?[month]?[eventDay] != nil {
                        //there is at least one event already on this date, add the event to the end of the array
                        
                        //get the array from the dictoinary
                        var array = eventsDictonary[year]?[month]?[eventDay]
                        //add the event on the end of the array
                        array?.append(event)
                        
                        //reset the value of the array in the dictionary
                        eventsDictonary[year]?[month]?[eventDay] = array
                        
                    }
                    //no events currently on this day
                    else {
                        eventsDictonary[year]?[month]?[eventDay] = [event]
                    }
                }

                //month not in the current year make it
                else {
                    eventsDictonary[year]?[month] = [eventDay : [event]]
                    
                }
            }
            //else intialize the new dictionary since it isn't in the dictionary
            else {
                //add the event to the dictionary
                eventsDictonary[year] = [month : [eventDay : [event]]]
            }
        }
        
        
        
        
        //clear the events out of the array to put the new ones in
        events = []
        //get all the info on today's date
        let currDate = NSDate()
        let year = String(yearFromDate(currDate))
        let month = String(monthFromDate(currDate))
        let day = String(dayFromDate(currDate))
        //get the events from the dictonary to display
        //events = (eventsDictonary[year]?[month]?[day])!
        
        //update table view to new events
        if eventsDictonary[year]?[month]?[day] != nil {
            events = (eventsDictonary[year]?[month]?[day])!
        }
            //no events, empty array
        else {
            events = []
        }
        
    }

}



