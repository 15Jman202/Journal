//
//  EntryController.swift
//  Journal
//
//  Created by Justin Carver on 8/25/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedController = EntryController()
    
    let fetchResultsController: NSFetchedResultsController
    
    init() {
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        let happySortDescriptor = NSSortDescriptor(key: "happy", ascending: false)
        let timestampSortDescipor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [happySortDescriptor, timestampSortDescipor]
        
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "happy", cacheName: nil)
        _ = try? fetchResultsController.performFetch()
    }
    
    func addEntry(title: String, text: String, isHappy: Bool) {
        let _ = Entry(title: title, text: text, isHappy: isHappy)
        saveToPersistentStorage()
    }

    func updateEntry(entry: Entry, title: String, text: String, isHappy: Bool) {
        entry.title = title
        entry.text = text
        entry.happy = isHappy
        saveToPersistentStorage()
        
    }
    
    func removeEntry(entry: Entry) {
        
        entry.managedObjectContext?.deleteObject(entry)
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
}


