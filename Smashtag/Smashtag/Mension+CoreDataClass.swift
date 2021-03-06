//
//  Mension+CoreDataClass.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(Mension)
public class Mension: NSManagedObject {
    class func addMensionWithKeyword(_ keyword: String,
                                     andType type: String,
                                     andTerm term:String, andTweetM tweetM:TweetM,
                                     inManagedObjectContext context: NSManagedObjectContext) -> Mension?
    {
        let request = NSFetchRequest<Mension>(entityName: "Mension")
        request.predicate = NSPredicate(format: "keyword  LIKE[cd] %@ AND term.term = %@", keyword, term)
        
        if let mentionM = (try? context.fetch(request))?.first  {
            // found this mension in the database, count + 1, return it ...
            mentionM.count = mentionM.count + 1
            
            let tweetMs =  mentionM.mutableSetValue(forKey: "tweetMs")
            tweetMs.add(object: tweetM)
            
            return mentionM
        } else if let mentionM = NSEntityDescription.insertNewObject(forEntityName: "Mension",
                                                                     into: context) as? Mension {
            // created a new mension in the database
            // load it up with information  ...
            mentionM.keyword = keyword
            mentionM.type = type
            mentionM.term = SearchTerm.termWithTerm(term, inManagedObjectContext: context)!
            mentionM.count = 1
            
            let tweetMs =  mentionM.mutableSetValue(forKey: "tweetMs")
            tweetMs.add(object: tweetM)
            
            return mentionM
        }
        
        return nil
    }
    
    class func mensionsWithTwitterInfo(_ twitterInfo: Twitter.Tweet, andTweetM tweetM:TweetM,
                                       andSearchTerm term: String,
                                       inManagedObjectContext context: NSManagedObjectContext)
    {
        let hashtags = twitterInfo.hashtags
        for hashtag in hashtags{
            _ =   Mension.addMensionWithKeyword(hashtag.keyword,
                                                andType: "Hashtags", andTerm: term, andTweetM: tweetM,inManagedObjectContext: context)
        }
        let users = twitterInfo.userMentions
        for user in users {
            _ =  Mension.addMensionWithKeyword(user.keyword, andType: "Users", andTerm: term,andTweetM:tweetM, inManagedObjectContext: context)
        }
        // userName
        let userScreenName = "@" + twitterInfo.user.screenName
        _ = Mension.addMensionWithKeyword(userScreenName, andType: "Users", andTerm: term, andTweetM:tweetM, inManagedObjectContext: context)
        
    }
    
    override public func prepareForDeletion() {
        guard let termMension = term else { return }
        if let mensions = termMension.mensions ,
            mensions.filter ({ !($0 as AnyObject).isDeleted }).isEmpty {
            managedObjectContext?.delete(termMension)
        }
    }
    
}
