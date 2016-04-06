//
//  WebViewController.swift
//  MapView
//
//  Created by James Rochabrun on 05-04-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    var busStop = NSDictionary()
    var url = NSString()

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string:self.url as String)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)

    }

  
    @IBAction func dismissButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});

        
    }
    


    
    
    
    
    
    

}
