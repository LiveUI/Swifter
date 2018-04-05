//
//  QueryExecutable.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation
@_exported import CoreData


public protocol QueryExecutable {
    associatedtype EntityType: Entity
    
    var entity: EntityType.Type { get }
    
    var filters: [QueryFilterGroup] { get set }
    var sorts: [QuerySort] { get set }
    var limit: Int? { get set }
    
    init(_ entityType: EntityType.Type)
    func fetchRequest() -> Entity.Request
}


extension QueryExecutable {
    
    /// Get compiled fetch request
    public func fetchRequest() -> Entity.Request {
        let fetch = Entity.Request(entityName: entity.entityName)
        fetch.predicate = filters.asPredicate()
        if !sorts.isEmpty {
            fetch.sortDescriptors = sorts.asSortDescriptors()
        }
        if let limit = limit {
            fetch.fetchLimit = limit
        }
        return fetch
    }

}

extension QueryExecutable where EntityType: NSManagedObject {
    
    public func all(on context: NSManagedObjectContext = CoreData.managedContext) throws -> [EntityType] {
        guard let data = try context.fetch(fetchRequest()) as? [EntityType] else {
            return []
        }
        return data
    }
    
    public func delete(on context: NSManagedObjectContext = CoreData.managedContext) throws {
        for object in try all(on: context) {
            try object.delete(on: context)
        }
        try context.save()
        
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest())
//        do {
//            let batchDeleteResult = try context.execute(deleteRequest) as! NSBatchDeleteResult
//            print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
//        } catch {
//            let updateError = error as NSError
//            print("\(updateError), \(updateError.userInfo)")
//        }
    }
    
    public func count(on context: NSManagedObjectContext = CoreData.managedContext) throws -> Int {
        return try context.count(for: fetchRequest())
    }
    
    public func first(on context: NSManagedObjectContext = CoreData.managedContext) throws -> EntityType? {
        return try context.fetch(fetchRequest()).first as? EntityType
    }
    
}
