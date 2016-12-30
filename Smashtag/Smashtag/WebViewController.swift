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
    
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    @IBAction func toRootViewController(_ sender: UIBarButtonItem) {
         _ = navigationController?.popToRootViewController(animated: true)
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
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        spinner.stopAnimating()
        print("This page can't be downloaded!")
    }

}
