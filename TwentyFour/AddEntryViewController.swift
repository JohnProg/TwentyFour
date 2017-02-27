//
//  AddEntryViewController.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 25/02/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import UIKit
import CoreLocation

class AddEntryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var charsLimitLabel: UILabel!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Entry Varaibles
    
    fileprivate var entryContent: String = "This is a demo content"
    fileprivate var entryImage: UIImage?
    fileprivate var entryTitle: String?
    fileprivate var entryDateCreation: Date = Date()
    fileprivate var entryLocation: CLLocation?
    fileprivate var entryMood: JournalEntry.Mood?
    
    // MARK: - location Varaibles
    fileprivate var locationManager: LocationManager!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @IBAction func addEntryJournalButtonAction() {
        //Accessing to the view context in the Persistent Container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        JournalEntry.journalEntryWIth(dateCreation: entryDateCreation, title: entryTitle!, content: entryContent, image: entryImage!, mood: entryMood!, location: entryLocation, context: context)
        
        
        //Save the data into the database
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //FIXME: - Missing the autoreturn to the master view
        
    }

    @IBAction func addImageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func moodSegmentedContolAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction func addLocationButtonAction(_ sender: UIButton) {
        locationManager = LocationManager()
        locationManager.onLocationFix = { placemark, error in
            if let placemark = placemark {
                self.entryLocation = placemark.location
                guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                
                sender.setTitle("\(name), \(city), \(area)", for: .normal)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Helpers
    func setupView() {
        setTitleFrom(date: entryDateCreation)
        setImageEntry(with: imageButton.currentImage!)
        setMoodEntry(segment: moodSegmentedControl)
    }
    
    func setTitleFrom(date: Date) {
        
        //creating the formatter and choosing the styles
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        //applaying the styles to the date
        entryTitle = formatter.string(from: date)
        
        //Updatting the title label
        titleLabel.text = entryTitle
    }
    
    func setImageEntry(with image: UIImage) {
        entryImage = image
    }
    
    func setMoodEntry(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        switch (index) {
            case 0: self.entryMood = JournalEntry.Mood.happy
            case 1: self.entryMood = JournalEntry.Mood.good
            case 2: self.entryMood = JournalEntry.Mood.bad
        default: self.entryMood = JournalEntry.Mood.good
        }
    }
}
