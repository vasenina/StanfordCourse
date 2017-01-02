//
//  TweetM+CoreDataClass.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import Foundation
import CoreData
import Twitter

@objc(TweetM)
public class TweetM: NSManagedObject {
    
    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext)-> TweetM?{
        let request = NSFetchRequest<TweetM>(entityName: "TweetM")
        request.predicate = NSPredicate(format : "unique = %@", twitterInfo.id)
        
        if let tweetM = (try? context.fetch(request))?.first{
            // found this tweet in the database, return it ...
            return tweetM
        } else if let tweetM = NSEntityDescription.insertNewObject(forEntityName: "TweetM",
                                                                   into: context) as? TweetM {
            // created a new tweet in the database
            tweetM.unique = twitterInfo.id
            tweetM.text   = twitterInfo.text
            tweetM.posted = twitterInfo.created as NSDate?
            return tweetM
        }
            
        return nil
    }


class func tweetWithTwitterInfo(_ twitterInfo: Twitter.Tweet,
                                andSearchTerm term: String,
                                inManagedObjectContext context: NSManagedObjectContext) -> TweetM?
{
    let request = NSFetchRequest<TweetM>(entityName: "TweetM")
    request.predicate = NSPredicate(
        format: "any terms.term contains[c] %@ and unique = %@", term,  twitterInfo.id)
    
    if let tweetM = (try? context.fetch(request))?.first {
          // found this tweet in the database, return it ...
        return tweetM
    } else {
        // get tweet, term and add terms to the tweet
        if let tweetM = TweetM.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: context),
            let currentTerm = SearchTerm.termWithTerm(term, inManagedObjectContext: context) {
            
            let terms = tweetM.mutableSetValue(forKey: "terms")
            terms.add(currentTerm)
            
            // add mensions
            Mension.mensionsWithTwitterInfo(twitterInfo,
                                            andSearchTerm: term,
                                            inManagedObjectContext: context)
        }
    }
    
    return nil
}


    class func newTweetsWithTwitterInfo(_ twitterInfo: [Twitter.Tweet],
                                        andSearchTerm term: String,
                                        inManagedObjectContext context: NSManagedObjectContext)
    {
        let request = NSFetchRequest<TweetM>(entityName: "TweetM")
        
        let newTweetsId = twitterInfo.map {$0.id}
        var newsSet = Set (newTweetsId)
        
        request.predicate = NSPredicate(
            format: "any terms.term contains[c] %@ and unique IN %@", term, newsSet)
        
        let results = try? context.fetch(request)
        if let tweets =  results  {
            let uniques = tweets.flatMap({ $0.unique})
            let uniquesSet = Set (uniques)
            
            newsSet.subtract(uniquesSet)
            print ("Count of new elements \(newsSet.count)")
            
            for unic in newsSet {
                if let index = twitterInfo.index(where: {$0.id == unic}){
                    // получаем твит, получаем терм и добавляем терм в terms для этого твита
                    
                    if let tweetM = TweetM.tweetWithTwitterInfo(twitterInfo: twitterInfo[index],
                                                                inManagedObjectContext: context),
                        let currentTerm = SearchTerm.termWithTerm(term,
                                                                  inManagedObjectContext: context){
                        let terms = tweetM.mutableSetValue(forKey: "terms")
                        terms.add(currentTerm)
                        
                        // add mensions
                        Mension.mensionsWithTwitterInfo(twitterInfo[index],
                                                        andSearchTerm: term,
                                                        inManagedObjectContext: context)
                    }
                }
            }
        }
    }



}
