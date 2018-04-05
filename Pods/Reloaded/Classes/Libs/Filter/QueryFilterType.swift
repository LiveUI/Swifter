//
//  QueryFilterType.swift
//  Reloaded
//
//  Created by Ondrej Rafaj on 29/03/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


public struct QueryFilterType: Equatable {
    
    enum Storage: Equatable {
        case equals
        case contains
        case beginsWith
        case endsWith
        case notEquals
        case greaterThan
        case lessThan
        case greaterThanOrEquals
        case lessThanOrEquals
        case custom(String)
    }
    
    public var interpretation: String {
        switch storage {
        case .equals:
            return "=="
        case .contains:
            return "CONTAINS"
        case .beginsWith:
            return "BEGINSWITH"
        case .endsWith:
            return "ENDSWITH"
        case .notEquals:
            return "!="
        case .greaterThan:
            return ">"
        case .lessThan:
            return "<"
        case .greaterThanOrEquals:
            return ">="
        case .lessThanOrEquals:
            return "<="
        case .custom(let custom):
            return custom
        }
    }
    
    /// Internal storage.
    let storage: Storage
    
    /// ==
    public static var equals: QueryFilterType { return .init(storage: .equals) }
    /// CONTAINS
    public static var contains: QueryFilterType { return .init(storage: .contains) }
    /// BEGINSWITH
    public static var beginsWith: QueryFilterType { return .init(storage: .beginsWith) }
    /// ENDSWITH
    public static var endsWith: QueryFilterType { return .init(storage: .endsWith) }
    /// !=
    public static var notEquals: QueryFilterType { return .init(storage: .notEquals) }
    /// >
    public static var greaterThan: QueryFilterType { return .init(storage: .greaterThan) }
    /// <
    public static var lessThan: QueryFilterType { return .init(storage: .lessThan) }
    /// >=
    public static var greaterThanOrEquals: QueryFilterType { return .init(storage: .greaterThanOrEquals) }
    /// <=
    public static var lessThanOrEquals: QueryFilterType { return .init(storage: .lessThanOrEquals) }
    
    /// Custom filter
    public static func custom(_ filter: String) -> QueryFilterType {
        return .init(storage: .custom(filter))
    }
    
}


