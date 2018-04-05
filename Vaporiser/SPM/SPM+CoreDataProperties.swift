//
//  SPM+CoreDataProperties.swift
//  
//
//  Created by Ondrej Rafaj on 05/04/2018.
//
//

import Foundation
import CoreData


extension SPM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SPM> {
        return NSFetchRequest<SPM>(entityName: "SPM")
    }

    @NSManaged public var path: String?
    @NSManaged public var name: String?

}
