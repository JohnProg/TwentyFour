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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        setupView()
        
        //Tapping in the view will close the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        
        //Creating an ImagePickerController
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Creating an Action Sheet
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        //Adding action to the Action Sheet: for Vamera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            //Code
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                //FIXME: - present an alert
                print("camera not aviable")
            }
        }))
        
        //Adding action to the Action Sheet: for Library
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in
            //Code
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        //Adding action to the Action Sheet: for Cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Presenting the Action Sheet
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func moodSegmentedContolAction(_ sender: UISegmentedControl) {
        setMoodEntry(segment: sender)
    }
    
    @IBAction func addLocationButtonAction(_ sender: UIButton) {
        //Activating the Activity Indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //Renaming the button
        sender.setTitle("Loading Location", for: .normal)
        
        //Location stuff
        locationManager = LocationManager()
        locationManager.onLocationFix = { placemark, error in
            if let placemark = placemark {
                self.entryLocation = placemark.location
                guard let city = placemark.locality, let area = placemark.administrativeArea else { return }
                
                //Renaming the button the the location info
                sender.setTitle("\(city), \(area)", for: .normal)
                
                //Disabling the Activity Indicator
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
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
        setImageEntry(with: imageView.image!)
        setMoodEntry(segment: moodSegmentedControl)
        
        activityIndicator.isHidden = true
    }
    
    /** This func will set the Title starting from a date: Date*/
    func setTitleFrom(date: Date) {
        
        //creating the formatter and choosing the styles
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        //applaying the styles to the date and saving it
        entryTitle = formatter.string(from: date)
        
        //Updating the title label
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

    //This func will close the the keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

//Conforming to delegates for the image picker
extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info [UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        setImageEntry(with: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
