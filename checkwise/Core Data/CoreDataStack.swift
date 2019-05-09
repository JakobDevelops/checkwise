//
//  CoreDataStack.swift
//  checkwise
//
//  Created by Jakob Wiemer on 09.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //Container thats interacts with the datamodel "Todos"
    var container : NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        
        //responsible for loading the data and setting up a store to save the items
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: + \(error!)")
                return
            }
        }
        
        return container
        
    }
    
    
    //Manages save, delete and update datamodel
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
