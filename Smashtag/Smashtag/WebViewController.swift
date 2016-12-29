//
//  WebViewController.swift
//  Smashtag
//
//  Created by user on 29/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class WebViewController: UIViewController , UIWebViewDelegate{

    var webUrl : URL?
    
   
    
    @IBOutlet weak var webView: UIWebView!{
        didSet{
            if webUrl != nil{
                webView.delegate = self
                self.title = webUrl!.host
                webView.scalesPageToFit = true
                webView.loadRequest(URLRequest(url: webUrl!))
            }
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
