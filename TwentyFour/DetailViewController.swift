//
//  DetailViewController.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 03/03/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    
    //MARK - Outlets 
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodIconView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var updateStackView: UIStackView!
    @IBOutlet weak var updateLabel: UILabel!
    
    //MARK - Variables 
    
    var journalEntry: JournalEntry?
    fileprivate var locationManager: LocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            try setupView()
        } catch ErrorType.entryIsNil {
            displayAlert(title: "(ErrorType.entryIsNil)", message: ErrorType.entryIsNil.rawValue)
        } catch {
            displayAlert(title: "Unknown Error", message: "An unknows error has occurred")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Actions
    
    
    @IBAction func editAction(_ sender: Any) {
        
        //Creating an Action Sheet
        let actionSheet = UIAlertController(title: "Edit Action", message: "Choose what would you like to do", preferredStyle: .actionSheet)
        
        //Adding action to the Action Sheet: for Vamera
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action:UIAlertAction) in
            //Code
            
        }))
        
        //Adding action to the Action Sheet: for Library
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) in
            //displaying the alert to ask confirmation
            let alertController = UIAlertController(title: "Delete Entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Confirm", style: .destructive, handler: {(alert: UIAlertAction!) in self.deleteEntry(entry: self.journalEntry!)})
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            
            
            
            self.present(alertController, animated: true, completion: nil)
        }))
        
        //Adding action to the Action Sheet: for Cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Presenting the Action Sheet
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    

    // MARK: - Helpers
    
    
    /**This func will setup the view */
    func setupView() throws {
        guard let entry = journalEntry else {
            throw ErrorType.entryIsNil
        }
        
        self.title = entry.title!
        imageView.image = UIImage(data: entry.image! as Data)
        textView.text = entry.content!
        
        if let location = entry.location {
            //setting the location
            locationManager = LocationManager()
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    guard let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(city), \(area)"
                }
            }
            locationManager.reverseGeoLoc(coordinate: (location.latitude, location.longitude))
        } else {
            locationStackView.isHidden = true
        }
        
        if let lastUpdate = entry.dateLastUpdate {
            updateLabel.text = setStringFromDate(date: lastUpdate as Date)
        } else {
            updateStackView.isHidden = true
        }
        
    }
    
    /**This func will display an alert */
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**This func will convert the date into a readble string */
    func setStringFromDate(date: Date) -> String {
        //creating the formatter and choosing the styles
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        //updating the title
        return formatter.string(from: date)
    }
    
    /**This func will delete the entry from the database */
    func deleteEntry(entry: JournalEntry) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(entry)
        
        
        //Save the data into the database
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //Fpop back to the navigation controller
        navigationController!.popViewController(animated: true)
    }
 

}

//MARK - Errors definition
extension DetailViewController {
    enum ErrorType: String, Error {
        case entryIsNil = "Ther's been a problem with the entry's data"
    }
}
