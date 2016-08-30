//
//  ListTableViewController.swift
//  Journal
//
//  Created by Caleb Hicks on 10/3/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EntryController.sharedController.fetchResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // What seque do I want to use?
        if segue.identifier == "toShowEntry" {
            
            // Where do I want to go
            let destinationVC = segue.destinationViewController as? EntryDetailViewController
            
            // What do I want to take with me
            guard let indexPath = tableView.indexPathForSelectedRow, let entry = EntryController.sharedController.fetchResultsController.objectAtIndexPath(indexPath) as? Entry else { return }
            
            // Pass the information
            destinationVC?.entry = entry
        }
    }
}
    
extension EntryListTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return EntryController.sharedController.fetchResultsController.sections?.count ?? 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.sharedController.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath)

        guard let entry = EntryController.sharedController.fetchResultsController.objectAtIndexPath(indexPath) as? Entry else { return UITableViewCell() }
        
        cell.textLabel?.text = entry.title

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            guard let entry = EntryController.sharedController.fetchResultsController.objectAtIndexPath(indexPath) as? Entry else { return }
            EntryController.sharedController.removeEntry(entry)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = EntryController.sharedController.fetchResultsController.sections, index = Int(sections[section].name) else { return nil }
        
        if index == 0 {
            return "Sad"
        } else {
            return "Happy"
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate Methods


extension EntryListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Insert:
            guard let newindexPath = newIndexPath else { return }
            tableView.insertRowsAtIndexPaths([newindexPath], withRowAnimation: .Fade)
        case .Move:
            guard let indexPath = indexPath, let newindexPath = newIndexPath else { return }
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: newindexPath)
        case .Update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch  type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
















