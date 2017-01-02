//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by user on 13/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    //var container : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    //var context = container.NSManagedObjectContext
    var context:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    var tweets = [Array<Tweet>](){
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String?{
        didSet{
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
            RecentSearches.add(searchText!)
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText, !query.isEmpty {
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets(){
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(newTweets, searchTerm: (weakSelf?.searchText)!)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    private func updateDatabase(_ newTweets: [Tweet], searchTerm: String){
        context?.perform {
            // более эффективный способ
            
             /* TweetM.newTweetsWithTwitterInfo(newTweets,
                                            andSearchTerm: self.searchText!,
                                            inManagedObjectContext: self.context!)
            
            */
            for twitterInfo in newTweets {
             _ = TweetM.tweetWithTwitterInfo(twitterInfo, andSearchTerm: self.searchText!, inManagedObjectContext: self.context!)
             }
            do {
                try self.context?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
        
        printDatabaseStatictic()
        print ("statistic Completed")
        
    }
    
    private func printDatabaseStatictic(){
         context?.perform {
            if let results = try? self.context!.fetch(NSFetchRequest(entityName: "TweetM")){
                print ("\(results.count) tweets")
            }
            //more efficient wayto count objects..
            if let mensionCount = try? self.context!.count(for: NSFetchRequest(entityName: "Mension")){
                print ("\(mensionCount) mensions")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchText = "#stanford"
        //automatic height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //-------- Stop Button -----
        
       /* let imageButton = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(TweetTableViewController.showImages(_:)))
        navigationItem.rightBarButtonItems = [imageButton]*/
        if let navCon = navigationController, navCon.viewControllers.count > 1 {
            
            let stopBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                    target: self,
                                                    action: #selector(TweetTableViewController.toRootViewController(_:)))
            
            if let rightBarButtonItem = navigationItem.rightBarButtonItem {
                navigationItem.rightBarButtonItems = [stopBarButtonItem, rightBarButtonItem]
            } else {
                navigationItem.rightBarButtonItem = stopBarButtonItem
            }
            
        }
    }
    
    func toRootViewController(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    /*func showImages(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Storyboard.ImagesIdentifier, sender: sender)
    }*/
    


    // MARK: - Table view data source
    
   /* override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }*/

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    private struct Storyboard{
        static let TweetCellIdentifier = "Tweet"
    }


  
    @IBOutlet weak var searchTextField: UITextField!
    {
        didSet{
        searchTextField.delegate = self
        searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "Show Mentions",
                let mtvc = segue.destination as? MentionsTableViewController,
                let tweetCell = sender as? TweetTableViewCell {
                mtvc.tweet = tweetCell.tweet}
        }
        
        
    }
    

}



