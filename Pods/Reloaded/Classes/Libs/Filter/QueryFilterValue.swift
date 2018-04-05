//
//  QueryFilterValue.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


/// Describes the values a subset can have.
public struct QueryFilterValue {
    
    enum QueryFilterValueStorage {
        case field(QueryField)
        case array([QueryDataRepresentable])
        case none
    }
    
    /// Internal storage.
    let storage: QueryFilterValueStorage
    
    /// Returns the `QueryField` value if it exists.
    public func field() -> QueryField? {
        switch storage {
        case .field(let field): return field
        default: return nil
        }
    }
    
//    /// Returns the `QueryData` value if it exists.
//    public func data() -> [QueryData]? {
//        switch storage {
//        case .data(let data): return [data]
//        case .array(let a): return a
//        default: return nil
//        }
//    }
    
    /// Another query field.
    public static func field(_ field: QueryField) -> QueryFilterValue {
        return .init(storage: .field(field))
    }
    
//    /// A single value.
//    public static func data<T>(_ data: T) throws -> QueryFilterValue {
//        return try .init(storage: .data(queryDataSerialize(data: data)))
//    }

//    /// A single value.
//    public static func array<T>(_ array: [T]) throws -> QueryFilterValue {
//        let array = try array.map { try queryDataSerialize(data: $0) }
//        return .init(storage: .array(array))
//    }

//    /// A sub query.
//    public static func subquery(_ subquery: DatabaseQuery) -> QueryFilterValue {
//        return .init(storage: .subquery(subquery))
//    }
    
    /// No value.
    public static func none() -> QueryFilterValue {
        return .init(storage: .none)
    }
}
