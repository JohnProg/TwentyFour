//
//  AddEntryViewController.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 25/02/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var charsLimitLabel: UILabel!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Entry Varaibles
    
    var entryContent: String?
    var entryImage: Data?
    var entryTitle: String?
    var entryDateCreation: Date = Date()
    

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
        
        let journalEntry = JournalEntry(context: context)
        journalEntry.dateCreation = entryDateCreation as NSDate?
        
        if let title = entryTitle {
            journalEntry.title = title
        } else {
            // FIXME: - Make an alert view
        }
        
        if let content = contentField.text { 
            journalEntry.content = content
        } else {
            // FIXME: - Make an alert view
            
            //Demo code
            journalEntry.content = "This is a demo content"
        }
        
        if let image = entryImage {
            journalEntry.image = image as NSData?
        }
        
        //Save the data into the database
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //FIXME: - Missing the autoreturn to the master view
        
        print(journalEntry)
        
    }

    @IBAction func addImageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func moodSegmentedContolAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction func addLocationButtonAction(_ sender: UIButton) {
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
        if let title = entryTitle {
            titleLabel.text = title
        }
        
        let imageData = imageToData(from: imageButton.currentImage!)
        setImageEntry(with: imageData)
    }
    
    func setTitleFrom(date: Date) {
        
        //creating the formatter and choosing the styles
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        //applaying the styles to the date
        entryTitle = formatter.string(from: date)
    }
    
    func imageToData(from image: UIImage) -> Data {
        let data = UIImageJPEGRepresentation(image, 1.0)!
        return data
    }
    
    func setImageEntry(with image: Data) {
        entryImage = image
    }
}
