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
     var isMapDetail = false
    
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //toggle to execute each VC 
        if self.isMapDetail == true {
            self.setValuesFromMapSegue()
        }else {
            self.setValuesFromCellSegue()
        }
        
        
    }

 
    
    //declaring the function for the segue coming from the Cells
    func setValuesFromCellSegue()
    {
        title = busStop.objectForKey("cta_stop_name") as? String
        self.labelA.text = busStop["stop_id"] as? String
        self.labelB.text = busStop["routes"] as? String
        self.labelC.text = busStop["longitude"] as? String
        self.labelD.text = busStop["latitude"] as? String


    }
    
    func setValuesFromMapSegue()
    {
        title = busStop.objectForKey("cta_stop_name") as? String
        self.labelA.text = busStop["stop_id"] as? String
        self.labelB.text = busStop["routes"] as? String
        self.labelC.text = busStop["longitude"] as? String
        self.labelD.text = busStop["latitude"] as? String
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        let webVc = segue.destinationViewController as? WebViewController
        
        let url = self.busStop.objectForKey("_address") as! String
        
        let name = self.busStop.objectForKey("cta_stop_name") as! String
        
        print(url)
        
        //passing the url
        webVc?.url = url
        
        //passing the name
        webVc!.name = name
        
        
    }
    
    
    
    
    
    
    
    
}
