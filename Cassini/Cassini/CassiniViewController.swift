//
//  CassiniViewController.swift
//  Cassini
//
//  Created by user on 14/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController , UISplitViewControllerDelegate
{

  
    
    private struct Storyboard{
        static let ShowImageSegue = "Show Image"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowImageSegue {
            if let ivc = segue.destination.contentViewController as? ImageViewController {
            //if let ivc = segue.destinationViewController as? ImageViewController {
                let imageName = (sender as? UIButton)?.currentTitle
                ivc.imageURL = DemoURL.NASAImageNamed(imageName)
                ivc.title = imageName
            }
        }

    }
    @IBAction func showImage(_ sender: UIButton) {
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            let imageName = sender.currentTitle
            ivc.imageURL = DemoURL.NASAImageNamed(imageName)
            ivc.title = imageName
        } else {
            performSegue(withIdentifier: Storyboard.ShowImageSegue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool
    {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController , ivc.imageURL == nil {
                return true
            }
        }
        return false
    }
    

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

