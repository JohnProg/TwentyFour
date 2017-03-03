//
//  EditViewController.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 03/03/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var charsLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK: - Variables
    var journalEntry: JournalEntry?
    fileprivate let limitOfChars = 300 //Change this constant to change the limit of chars accepted in the textView
    fileprivate var charsWritten = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            try setupView()
        } catch ErrorType.entryIsNil {
            self.displayAlert(title: "\(ErrorType.entryIsNil)", message: ErrorType.entryIsNil.rawValue)
        } catch {
            self.displayAlert(title: "Unknown Error", message: "An unknow error has occurred")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions 
    
    /**Action called on save */
    @IBAction func saveAction(_ sender: Any) {
        
        //Creating a new Date for the lastUpdateDate value
        let date = Date()
        
        //creating the context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            //Checking for content characters limit
            let content = try checkContent(content: textView.text)
            
            //Editing the entry with the new values
            let managedObject = self.journalEntry
            managedObject?.setValue(content, forKeyPath: "content")
            managedObject?.setValue(date, forKeyPath: "dateLastUpdate")
            
            //Save the context
            try context.save()
            
        }  catch ErrorType.entryContentIsEmpty {
            self.displayAlert(title: "\(ErrorType.entryContentIsEmpty)", message: ErrorType.entryContentIsEmpty.rawValue)
        } catch ErrorType.exceededCharactersLimit {
            self.displayAlert(title: "\(ErrorType.exceededCharactersLimit)", message: ErrorType.exceededCharactersLimit.rawValue)
        } catch {
            displayAlert(title: "Database Error", message: "An error has occurres. Unable to save the entry!")
        }
        
        //pop back to the navigation root controller
        navigationController!.popToRootViewController(animated: true)
        
    }
    
    
    //MARK: - Helpers
    
    /**This func will setup the view */
    func setupView() throws {
        
        let borderColor: UIColor = .lightGray
        textView.layer.borderColor = borderColor.cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        
        guard let entry = journalEntry else {
            throw ErrorType.entryIsNil
        }
        textView.text = entry.content
        charsWritten = textView.attributedText.length
        updateCharsLimitLabel(with: charsWritten, limit: limitOfChars)
    }
    
    
    /**This func will update the the chars limitLabel */
    func updateCharsLimitLabel(with nChars: Int, limit: Int) {
        charsLabel.text = "\(nChars) / \(limit)"
        
        if nChars <= limit {
            charsLabel.textColor = UIColor.darkGray
        } else {
            charsLabel.textColor = UIColor.red
        }
    }
    
    /**This func will set the content */
    func checkContent(content: String?) throws -> String {
        //Check if there is a content
        guard let content = content, content != "" else {
            throw ErrorType.entryContentIsEmpty
        }
        //Check if the content isn't too long
        if charsWritten > limitOfChars {
            throw ErrorType.exceededCharactersLimit
        }
        
        return content
    }
    
    /**This func will display an alert */
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }

}

//Using UITextViewDelegate
extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        charsWritten = textView.attributedText.length
        updateCharsLimitLabel(with: charsWritten, limit: limitOfChars)
    }
}

//Adding Error Types
extension EditViewController {
    enum ErrorType: String, Error {
        case entryContentIsEmpty = "The content for the entry is missing."
        case exceededCharactersLimit = "You have exceeded the characters limit."
        case entryIsNil = "Ther's been a problem with the entry's data"
    }
}
