//
//  TweetM+CoreDataProperties.swift
//  CoreData test
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TweetM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetM> {
        return NSFetchRequest<TweetM>(entityName: "TweetM");
    }

    public var text: String?
    @NSManaged public var posted: NSDate?
    @NSManaged public var unique: String?

}
