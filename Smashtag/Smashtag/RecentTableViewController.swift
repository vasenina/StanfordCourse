//
//  RecentTableViewController.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 29/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit
import CoreData

class RecentTableViewController: UITableViewController {
    
    
    var recentSearches:[String]{
        return RecentSearches.searches
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    private struct Storyboard{
        static let RecentCell = "Recent Cell"
        static let TweetsSegue = "Show Recent Tweets"
        static let PopularSegue = "ShowPopularMensions"
    }
    
    var context: NSManagedObjectContext?
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.RecentCell, for: indexPath) as UITableViewCell
        cell.textLabel?.text = recentSearches[indexPath.row]

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            RecentSearches.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == Storyboard.TweetsSegue,
            let cell = sender as? UITableViewCell,
            let ttvc = segue.destination as? TweetTableViewController{
                ttvc.searchText = cell.textLabel?.text
            }
            if identifier == Storyboard.PopularSegue,
            let cell = sender as? UITableViewCell,
            let ptwc = segue.destination as? PopularityTableViewController{
                ptwc.mention = cell.textLabel?.text
                ptwc.popcontext = context
            }
        
            
        }
    }
    
        

    }
    
