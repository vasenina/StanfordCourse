//
//  SearchTerm+CoreDataClass.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData

@objc(SearchTerm)
public class SearchTerm: NSManagedObject {
    class func termWithTerm(_ term: String,
                            inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm?
    {
        let request = NSFetchRequest<SearchTerm>(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "term = %@", term)
        if let searchTerm = (try? context.fetch(request))?.first {
            return searchTerm
        } else if let searchTerm = NSEntityDescription.insertNewObject(forEntityName: "SearchTerm",
                                                                       into: context) as? SearchTerm  {
            searchTerm.term = term
            return  searchTerm
        }
        return nil
    }
}
