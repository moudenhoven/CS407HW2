//
//  ViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/5/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit
import CVCalendar


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
       
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}

extension UIViewController : CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    public func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    public func firstWeekday() -> Weekday {
        return .Sunday
    }
}