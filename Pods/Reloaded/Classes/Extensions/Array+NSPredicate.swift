//
//  Array+NSPredicate.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


extension Array where Element: NSPredicate {
    
    /// Group an array of predicates with AND logical type
    public func andGroup() -> NSPredicate {
        return group(type: .and)
    }
    
    /// Group an array of predicates with OR logical type
    public func orGroup() -> NSPredicate {
        return group(type: .or)
    }
    
    /// Group an array of predicates with NOT logical type
    public func notGroup() -> NSPredicate {
        return group(type: .not)
    }
    
    /// Group an array of predicates
    public func group(type: NSCompoundPredicate.LogicalType) -> NSPredicate {
        let predicate = NSCompoundPredicate(type: type, subpredicates: self)
        return predicate
    }
    
}
