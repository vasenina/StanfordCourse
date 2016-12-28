//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 28/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit
import Twitter


class MentionsTableViewController: UITableViewController {
    
 
    @IBAction func toRootViewController(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var tweet: Tweet?{
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media   , media.count > 0 {
                mentionSections.append(MentionSection(type: "Images",
                                                      mentions: media.map { MentionItem.image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls   , urls.count > 0 {
                mentionSections.append(MentionSection(type: "URLs",
                                                      mentions: urls.map { MentionItem.keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags  , hashtags.count > 0 {
                mentionSections.append(MentionSection(type: "Hashtags",
                                                      mentions: hashtags.map { MentionItem.keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions {
                var userItems = [MentionItem]()
                //------- Extra Credit 1 -------------
                if let screenName = tweet?.user.screenName {
                    userItems += [MentionItem.keyword("@" + screenName)]
                }
                //------------------------------------------------
                if users.count > 0 {
                    userItems += users.map { MentionItem.keyword($0.keyword) }
                }
                if userItems.count > 0 {
                    mentionSections.append(MentionSection(type: "Users", mentions: userItems))
                }
            }
        }
    }
    
    // MARK: // private properties
    
    private var mentionSections: [MentionSection] = []
    
    private struct MentionSection: CustomStringConvertible
    {
        var type: String
        var mentions: [MentionItem]
        var description: String { return "\(type): \(mentions)" }
    }
    
    private enum MentionItem: CustomStringConvertible
    {
        case keyword(String)
        case image(URL, Double)
        
        var description: String {
            switch self {
            case .keyword(let keyword): return keyword
            case .image(let url, _): return url.path
            }
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentionSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentionSections[section].mentions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Keyword Cell",
                                                     for: indexPath)
            cell.textLabel?.text = keyword
            return cell
            
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell",
                                                     for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageUrl = url
            }
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return mentionSections[section].type
    }
   
   
}
