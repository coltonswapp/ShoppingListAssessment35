//
//  ListItem+Convenience.swift
//  ShoppingList-Assessment2
//
//  Created by Colton Swapp on 7/31/20.
//  Copyright © 2020 Colton Swapp. All rights reserved.
//

import Foundation
import CoreData

extension ListItem {
    convenience init(itemName: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.itemName = itemName
        self.isComplete = isComplete
    }
}
