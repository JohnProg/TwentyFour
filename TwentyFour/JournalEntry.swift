//
//  JournalEntry.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 27/02/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

extension JournalEntry {
    enum Mood: String, RawRepresentable {
        case happy = "happy"
        case avarage = "avarage"
        case bad = "bad"
    }
}

extension JournalEntry {
    class func journalEntryWIth(dateCreation: Date, title: String, content: String, image: UIImage, mood: Mood, location: CLLocation?, context: NSManagedObjectContext) {
        
        let entry = JournalEntry(context: context)
        
        entry.dateCreation = dateCreation as NSDate?
        entry.title = title
        entry.content = content
        entry.addImage(image: image)
        entry.mood = mood.rawValue
        
        
        
    }
}

extension JournalEntry {
    
    func addImage(image: UIImage) {
        let dataImage = UIImageJPEGRepresentation(image, 1.0)!
        self.image = dataImage as NSData?
    }
    
    func addLocation(_ location: CLLocation?, context: NSManagedObjectContext ) {
        
        //if the location is not nil
        if let location = location {
            //creating the location
            let entryLocation = Location.locationWith(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, context: context)
            //adding the location
            self.location = entryLocation
        }
    }
}
