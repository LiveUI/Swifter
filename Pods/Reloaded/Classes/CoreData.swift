//
//  CoreData.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation
@_exported import CoreData


public class CoreData {
    
    /// Custom CoreData errors
    public enum Problem: Error {
        case unableToCreateEntity
        case badData
        case invalidPersistentStoreCoordinator
    }
    
    /// Default implementation, should be sufficient in most cases
    public static let `default` = CoreData()
    
    let containerName: String
    
    // MARK: Initialization
    
    /// Initialize CoreData with an optional NSPersistentContainer name.
    /// App name will be used as default if nil
    public init(containerName: String? = nil) {
        guard let containerName = containerName ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String else {
            fatalError("CoreData container name is not set and can not be inferred")
        }
        self.containerName = containerName
    }
    
    // MARK: Basic methods
    
    /// Managed context for this instance
    public var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Default managed context
    public static var managedContext: NSManagedObjectContext {
        return CoreData.default.persistentContainer.viewContext
    }
    
    /// Create new entry on the default context
    public static func new<T>(_ entityClass: T.Type, on context: NSManagedObjectContext = CoreData.managedContext) throws -> T where T: Entity {
        let o = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context)
        guard let object = o as? T else {
            throw Problem.unableToCreateEntity
        }
        return object
    }
    
    // MARK: Default CoreData stuff
    
    /// Persistent connector for this instance
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: CoreData save support
    
    /// Save managed context if it has changes
    public func saveContext() throws {
        try CoreData.save(context: managedContext)
    }
    
    /// Save default managed context if it has changes
    public static func saveContext() throws {
        try CoreData.save(context: managedContext)
    }
    
    // MARK: Private interface
    
    private static func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
}
