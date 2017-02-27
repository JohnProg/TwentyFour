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
    @IBOutlet weak var contentField: UITextView!
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
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        

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
        
        //FIXME: - This is not the proper way
        if contentField.text != "" {
            self.entryContent = contentField.text!
        }
        
        //Creating the journal Entry in the context
        JournalEntry.journalEntryWIth(dateCreation: entryDateCreation, title: entryTitle!, content: entryContent, image: entryImage!, mood: entryMood!, location: entryLocation, context: context)
        
        
        //Save the data into the database
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //Fpop back to the navigation controller
        navigationController!.popViewController(animated: true)
        
    }

    @IBAction func addImageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func moodSegmentedContolAction(_ sender: UISegmentedControl) {
        setMoodEntry(segment: sender)
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
    
    
    // MARK: - Helpers
    /** This func will style the view, and will setup the basic variables for the entry creation */
    func setupView() {
        
        
        
        let borderColor: UIColor = .lightGray
        contentField.layer.borderColor = borderColor.cgColor;
        contentField.layer.borderWidth = 1.0;
        contentField.layer.cornerRadius = 5.0;
        
        setTitleFrom(date: entryDateCreation)
        setImageEntry(with: imageButton.currentImage!)
        setMoodEntry(segment: moodSegmentedControl)
    }
    
    /** This func will set the Title starting from a date: Date*/
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
    
    /**This func will set the image of the Entry */
    func setImageEntry(with image: UIImage) {
        entryImage = image
    }
    
    /**This func will set the mood of the Entry */
    func setMoodEntry(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.entryMood = JournalEntry.Mood.happy
        }
        
        if segment.selectedSegmentIndex == 1 {
            self.entryMood = JournalEntry.Mood.avarage
        }
        
        if segment.selectedSegmentIndex == 2 {
            self.entryMood = JournalEntry.Mood.bad
        }
    }
}
