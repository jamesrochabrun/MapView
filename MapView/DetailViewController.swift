//
//  DetailViewController.swift
//  MapView
//
//  Created by James Rochabrun on 05-04-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
     var busStop = NSDictionary()
    
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    @IBOutlet weak var labelE: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(busStop)
        title = busStop["name"] as? String
    }

 
    
    
    
    
    
    
    
    
    
    
    
    
}
