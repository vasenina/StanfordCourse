//
//  Mension+CoreDataProperties.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData


extension Mension {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mension> {
        return NSFetchRequest<Mension>(entityName: "Mension");
    }

    @NSManaged public var type: String?
    @NSManaged public var keyword: String?
    @NSManaged public var count: Int16
    @NSManaged public var term: SearchTerm?

}
