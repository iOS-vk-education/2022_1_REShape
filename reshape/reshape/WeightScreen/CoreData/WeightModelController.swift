//
//  DataController.swift
//  reshape
//
//  Created by Иван Фомин on 22.04.2022.
//

import Foundation
import UIKit
import CoreData

class WeightModelController: NSObject {
    var persistentContainer: NSPersistentContainer
    var managedObjectContext: NSManagedObjectContext
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "WeightModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
        managedObjectContext = persistentContainer.viewContext
    }
    
    func saveContext() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            managedObjectContext.rollback()
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
