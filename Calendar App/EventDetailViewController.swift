//
//  EventDetailViewController.swift
//  Calendar App
//
//  Created by Michael Oudenhoven on 3/6/16.
//  Copyright © 2016 Michael Oudenhoven. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var deleteEventButton: UIButton!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //put a border on the delete button
        deleteEventButton.layer.cornerRadius = 15
        deleteEventButton.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        deleteEventButton.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBActions
    @IBAction func deleteClicked(sender: AnyObject) {
        
        
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
