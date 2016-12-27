//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by user on 13/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    struct Palette{
        static let hashtagColor  = UIColor.red
        static let urlColor = UIColor.blue
        static let userColor = UIColor.purple
    }
    
    private func setTextLabel(_ tweet: Tweet) -> NSMutableAttributedString{
        var tweetText: String = tweet.text
        for _ in tweet.media{
            tweetText += " 📷"
        }
        let attribText = NSMutableAttributedString(string: tweetText)
        
        attribText.setMensionsColor(tweet.hashtags, color: Palette.hashtagColor)
        attribText.setMensionsColor(tweet.urls, color: Palette.urlColor)
        attribText.setMensionsColor(tweet.userMentions, color: Palette.userColor)
        
        return attribText
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.attributedText = setTextLabel(tweet)    
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = try? Data(contentsOf: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            let formatter = DateFormatter()
            if  Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
        
    }
}

private extension NSMutableAttributedString {
    func setMensionsColor(_ mensions: [Mention], color: UIColor) {
        for mension in mensions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mension.nsrange)
        }
    }
}
