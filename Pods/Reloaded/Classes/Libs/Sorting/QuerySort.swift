//
//  QuerySort.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 30/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


/// Sorts results based on a field and direction.
public struct QuerySort {
    /// The field to sort.
    public let field: QueryField
    
    /// The direction to sort by.
    public let direction: ComparisonResult
    
    /// Create a new sort
    public init(
        field: QueryField,
        direction: ComparisonResult
        ) {
        self.field = field
        self.direction = direction
    }
}

extension QuerySort {
    
    public func asSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: field.name, ascending: direction == .orderedAscending)
    }
    
}


extension Array where Element == QuerySort {
    
    public func asSortDescriptors() -> [NSSortDescriptor] {
        return map({ $0.asSortDescriptor() })
    }
    
}
