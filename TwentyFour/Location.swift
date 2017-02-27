//
//  Location.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 27/02/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import Foundation
import CoreData


extension Location {
    class func locationWith(latitude: Double, longitude: Double, context: NSManagedObjectContext) -> Location {

        let location = Location(context: context)
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }

}
