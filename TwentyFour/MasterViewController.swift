//
//  MasterViewController.swift
//  TwentyFour
//
//  Created by Andrea Miotto on 24/02/17.
//  Copyright © 2017 Andrea Miotto. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    //MARK: - Variables
    var journalEntries: [JournalEntry] = []
    fileprivate var locationManager: LocationManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleFromCurrentDate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //get the data
        getData()
        //reload the table
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            /*
            if let indexPath = self.tableView.indexPathForSelectedRow {
            //TODO: - show details for entry
            }
             */
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        //FIXME: - this should be divided into different sections, depending on the month
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let journalEntry = self.journalEntries[indexPath.row]
        configureCell(cell: cell, withEntry: journalEntry)
        return cell
    }
    
    

    //MARK: - Helpers
    
    /** This func will get the data from the CoreData Database */
    func getData() {
        //as always I need a context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //try the fetch
        do {
            //Creating a request
            let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
            //Creating a Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "dateCreation", ascending: false)
            //Set the sort Desriptor to the request
            fetchRequest.sortDescriptors = [sortDescriptor]
            // Set the batch size to a suitable number.
            fetchRequest.fetchBatchSize = 20
            //Requesting..
            journalEntries = try context.fetch(fetchRequest)
        } catch {
            //FIXME: - Handle the erros
            print("Fetch failed")
        }
    }
    
    /**This func will style the cell prperly */
    func configureCell(cell: TableViewCell, withEntry entry: JournalEntry) {
        
        //setting the easy stuff
        cell.titleLabel.text = entry.title!
        cell.entryImageView.image = UIImage(data: entry.image! as Data)
        cell.contentLabel.text = entry.content!
        
        //setting the mood
        switch (entry.mood!) {
            case "happy": cell.moodIconView.image = #imageLiteral(resourceName: "icn_happy")
            case "avarage": cell.moodIconView.image = #imageLiteral(resourceName: "icn_average")
            case "bad": cell.moodIconView.image = #imageLiteral(resourceName: "icn_bad")
            default: cell.moodIconView.image = #imageLiteral(resourceName: "icn_average")
        }
        
        //setting the location
        locationManager = LocationManager()
        locationManager.onLocationFix = { placemark, error in
            if let placemark = placemark {
                guard let city = placemark.locality, let area = placemark.administrativeArea else { return }
                
                cell.locationLabel.text = "\(city), \(area)"
            }
        }
        guard let location = entry.location else {
            cell.locationLabel.text = ""
            return
        }
        locationManager.reverseGeoLoc(coordinate: (location.latitude, location.longitude))
    }
    
    
    /** This func will set the Title starting from a date: Date*/
    func setTitleFromCurrentDate() {
        let date = Date()
        //creating the formatter and choosing the styles
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        //updating the title
        self.title = formatter.string(from: date)
    }
    
    
}

