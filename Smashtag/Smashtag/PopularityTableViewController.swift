//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 02/01/2017.
//  Copyright © 2017 Vasenina. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController:  CoreDataTableViewController {

    var mention : String? {didSet{updateUI()}}
    var popcontext: NSManagedObjectContext?{
        didSet{updateUI()}
    }
    
    private func updateUI(){
        if let context = popcontext , let mentionString = mention,
            mentionString.characters.count > 0 {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mension")
            request.predicate = NSPredicate(format: "term.term contains[c] %@ AND count > %@",
                                            mention!, "1")
            request.sortDescriptors = [NSSortDescriptor(
                key: "type",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ), NSSortDescriptor(
                    key: "count",
                    ascending: false
                ),NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
        
    }
    
    private struct Storyboard{
        static let MensionCell = "PopularMensionsCell"
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if popcontext == nil {
            popcontext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext

            }
        }
    
    
    // MARK: UITableViewDataSource
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MensionCell,
                                                 for: indexPath)
        var keyword: String?
        var count: String?
        if let mensionM = fetchedResultsController?.object(at: indexPath) as? Mension {
            mensionM.managedObjectContext?.performAndWait {  // asynchronous
                keyword =  mensionM.keyword
                count =  String(mensionM.count)
            }
            cell.textLabel?.text = keyword
            cell.detailTextLabel?.text = "tweets: " + (count ?? "-")
        }
        return cell
    }

}
