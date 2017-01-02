//
//  TweetM+CoreDataProperties.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData


extension TweetM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetM> {
        return NSFetchRequest<TweetM>(entityName: "TweetM");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var terms: NSSet?

}

// MARK: Generated accessors for terms
extension TweetM {

    @objc(addTermsObject:)
    @NSManaged public func addToTerms(_ value: SearchTerm)

    @objc(removeTermsObject:)
    @NSManaged public func removeFromTerms(_ value: SearchTerm)

    @objc(addTerms:)
    @NSManaged public func addToTerms(_ values: NSSet)

    @objc(removeTerms:)
    @NSManaged public func removeFromTerms(_ values: NSSet)

}
