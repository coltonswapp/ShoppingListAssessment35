//
//  ListItemController.swift
//  ShoppingList-Assessment2
//
//  Created by Colton Swapp on 7/31/20.
//  Copyright © 2020 Colton Swapp. All rights reserved.
//

import Foundation
import CoreData

class ListItemController {
    
    // MARK: - Shared Instance
    static let sharedInstance = ListItemController()
    
    
    // MARK: - Source of truth via the FRC
    let fetchedResultsController: NSFetchedResultsController<ListItem>
    
    init() {
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true)]
        
        let resultsController: NSFetchedResultsController<ListItem> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    
        fetchedResultsController = resultsController
    
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching the necessary data.")
        }
    }
    
    // MARK: - CRUDFUNCS
    
    func create(for item: String) {
        _ = ListItem(itemName: item)
        // Save
        saveToPersistence()
    }
    
    func updateCompletionStatus(listItem: ListItem) {
        listItem.isComplete = !listItem.isComplete
        // Save
        saveToPersistence()
        
    }
    
    func remove(listItem: ListItem) {
        let moc = CoreDataStack.context
        moc.delete(listItem)
        // Save
        saveToPersistence()
    }
    
    // MARK: - Persistence
    func saveToPersistence() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let saveError {
            print("There was an error saving to persistent store. \(saveError)")
        }
    }
}
