//
//  Mension+CoreDataProperties.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 03/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData


extension Mension {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mension> {
        return NSFetchRequest<Mension>(entityName: "Mension");
    }

    @NSManaged public var count: Int16
    @NSManaged public var keyword: String?
    @NSManaged public var type: String?
    @NSManaged public var term: SearchTerm?
    @NSManaged public var tweetMs: NSSet?

}

// MARK: Generated accessors for tweetMs
extension Mension {

    @objc(addTweetMsObject:)
    @NSManaged public func addToTweetMs(_ value: TweetM)

    @objc(removeTweetMsObject:)
    @NSManaged public func removeFromTweetMs(_ value: TweetM)

    @objc(addTweetMs:)
    @NSManaged public func addToTweetMs(_ values: NSSet)

    @objc(removeTweetMs:)
    @NSManaged public func removeFromTweetMs(_ values: NSSet)

}
