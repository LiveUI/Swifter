//
//  Filters.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


extension Query {
    
    /// Basic filter
    @discardableResult public func filter(_ filters: QueryFilter ...) -> Self {
        self.filters.append(.group(.and, filters))
        return self
    }
    
    /// Basic filter
    @discardableResult public func filter(_ operator: QueryFilterGroup.Operator, _ filters: QueryFilter ...) -> Self {
        self.filters.append(.group(`operator`, filters))
        return self
    }
    
}

/// field == value
public func == (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .equals, rhs)
}
public func == (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .equals, rhs)
}

/// field == value, case insensitive
infix operator ==*
public func ==* (lhs: String, rhs: StringQueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .equals, rhs, false)
}
public func ==* (lhs: String, rhs: StringQueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .equals, rhs, false)
}

/// field CONTAINS value
infix operator ~~
public func ~~ (lhs: String, rhs: StringQueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .contains, rhs)
}

/// field CONTAINS value, case insensitive
infix operator ~~*
public func ~~* (lhs: String, rhs: StringQueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .contains, rhs, false)
}

/// field != value
public func != (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .notEquals, rhs)
}
public func != (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .notEquals, rhs)
}

/// field != value, case insensitive
infix operator !=*
public func !=* (lhs: String, rhs: StringQueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .notEquals, rhs, false)
}
public func !=* (lhs: String, rhs: StringQueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .notEquals, rhs, false)
}

/// field > value
public func > (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .greaterThan, rhs)
}
public func > (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .greaterThan, rhs)
}

/// field < value
public func < (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .lessThan, rhs)
}
public func < (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .lessThan, rhs)
}

/// field >= value
public func >= (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .greaterThanOrEquals, rhs)
}
public func >= (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .greaterThanOrEquals, rhs)
}

/// field <= value
public func <= (lhs: String, rhs: QueryDataRepresentable) -> QueryFilter {
    return _compare(lhs, .lessThanOrEquals,  rhs)
}
public func <= (lhs: String, rhs: QueryDataRepresentable?) -> QueryFilter {
    return _compare(lhs, .lessThanOrEquals, rhs)
}

extension QueryFilter {

    public static func custom(_ lhs: String, _ comparison: QueryFilterType, _ rhs: QueryDataRepresentable?, caseSensitive: Bool = true) -> QueryFilter {
        return _compare(lhs, comparison, rhs, caseSensitive)
    }
    
}

private func _compare(_ lhs: String, _ comparison: QueryFilterType, _ rhs: QueryDataRepresentable?, _ caseSensitive: Bool = true) -> QueryFilter {
    return QueryFilter(field: QueryField(name: lhs), type: comparison, value: rhs ?? NULL(), caseSensitive: caseSensitive)
}



