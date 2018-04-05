//
//  Query.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


/// Root query available for each NSManagedObject conforming to Entity
public class Query<QueryEntityType>: QueryExecutable where QueryEntityType: Entity {    
    
    /// Name of the entity this query will be executed on
    public var entity: QueryEntityType.Type
    
    /// Query filters separated in logical groups
    public var filters: [QueryFilterGroup] = []
    
    /// Sorting results of the query
    public var sorts: [QuerySort] = []
    
    /// Limit the number of items
    public var limit: Int?
    
    /// Initialization
    public required init(_ entityType: QueryEntityType.Type) {
        self.entity = entityType
    }
    
}
