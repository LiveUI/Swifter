//
//  Entity.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation
@_exported import CoreData

/// Type erased Entity
public protocol AnyEntity: class {
    /// Name of the entity
    static var entityName: String { get }
}

/// Entity
public protocol Entity: AnyEntity { }

/// Entity extension for NSManagedObject
extension Entity where Self: NSManagedObject {
    
    /// Typealias for NSFetchRequest
    public typealias Request = NSFetchRequest<NSFetchRequestResult>
    
    /// Name of the entity, converted from the name of the class by default
    public static var entityName: String {
        let name = String(describing: self)
        return name
    }
    
    /// Create new query
    public static var query: Query<Self> {
        print(self)
        return Query(self)
    }
    
    /// Basic fetch request
    public static var fetchRequest: Request {
        let fetch = Request(entityName: entityName)
        return fetch
    }
    
    /// Get all items based on optional criteria and sorting
    public static func all(filter: NSPredicate? = nil, sort: [NSSortDescriptor] = [], limit: Int = 0) throws -> [Self] {
        let fetch = fetchRequest
        fetch.predicate = filter
        if !sort.isEmpty {
            fetch.sortDescriptors = sort
        }
        if limit > 0 {
            fetch.fetchLimit = limit
        }
        guard let all = try CoreData.managedContext.fetch(fetch) as? [Self] else {
            throw CoreData.Problem.badData
        }
        return all
    }
    
    /// Delete all data for this entity
    public static func deleteAll(on context: NSManagedObjectContext = CoreData.managedContext) throws {
        try query.delete(on: context)
    }
    
    /// Delete this object
    @discardableResult public func delete(on context: NSManagedObjectContext = CoreData.managedContext) throws -> Bool {
        context.delete(self)
        try save(on: context)
        return isDeleted
    }
    
    /// Count all items
    public static func count() throws -> Int {
        let count = try CoreData.managedContext.count(for: fetchRequest)
        return count
    }
    
    /// Save context
    public func save(on context: NSManagedObjectContext = CoreData.managedContext) throws {
        try context.save()
    }
    
    /// Create new entity
    public static func new(on context: NSManagedObjectContext = CoreData.managedContext) throws -> Self {
        let object = try CoreData.new(Self.self, on: context)
        return object
    }
    
}
