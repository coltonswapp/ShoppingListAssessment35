//
//  CoreDataStack.swift
//  ShoppingList-Assessment2
//
//  Created by Colton Swapp on 7/31/20.
//  Copyright © 2020 Colton Swapp. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList_Assessment2")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Error is persisting the data.")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext { return container.viewContext}
}
