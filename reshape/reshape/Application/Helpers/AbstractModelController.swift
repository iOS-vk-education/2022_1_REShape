//
//  AbstractModelController.swift
//  reshape
//
//  Created by Иван Фомин on 26.04.2022.
//

import Foundation
import CoreData

class AbstractModelController: NSObject {
    private var persistentContainer: NSPersistentContainer
    var managedObjectContext: NSManagedObjectContext
    init(databaseName name: String, completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: name)
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
    
    func flushData(entityName name: String) {
        // Очистка базы данных
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
            let result = try managedObjectContext.fetch(fetchRequest)
            for model in result {
                managedObjectContext.delete(model)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        saveContext()
    }
}
