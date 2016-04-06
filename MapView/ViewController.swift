//
//  ViewController.swift
//  MapView
//
//  Created by James Rochabrun on 05-04-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var busStops = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControlBar: UISegmentedControl!
    var busAnotation  = MKPointAnnotation()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //segmented controller
        self.tableView.hidden = true
        
        //json catch
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/bus.json")
        let session = NSURLSession.sharedSession()
        
        
        
        let task = session.dataTaskWithURL(url!) { (data:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
            do {
                self.busStops = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)["row"] as! [NSDictionary]
                
                //need to refresh data after finish loading, puts this back in the main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.tableView.reloadData()
                    
                    for busStop in self.busStops{
                        
                        
                        //let x = Double(busStop["latitude"] as! string!)!
                        let x = busStop.objectForKey("latitude") as! String
                        let y = busStop.objectForKey("longitude") as! String
                        let latitude = Double(x)!
                        let longitude = Double(y)!
                        
                        
                        //we have to create a new MkpointAnotation object first if not we will not get all the pins
                        let annotation = MKPointAnnotation()
                        
                        //we pass the longitude and longitude
                        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        
                        //setting the title and routes
                        annotation.title = busStop.objectForKey("cta_stop_name") as? String
                        annotation.subtitle = busStop.objectForKey("routes") as? String
                        
                        //this adds the anotations to the map
                        self.mapView.addAnnotation(annotation)
                        
                        //debugging
                        print(self.busStops.count, latitude, longitude)
                        
                    }//here is the end of the for loop
            
                })
                
            }catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
        
        //this is for the zoom
        self.zoomMap()
    }

    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        
        switch self.segmentedControlBar.selectedSegmentIndex
        {
            case 0 :
            self.tableView.hidden = true
            self.mapView.hidden = false
            case 1:
            self.mapView.hidden = true
            self.tableView.hidden = false
        default:
            break;
            
        }
   
    }
    
    //making the zoom
    func zoomMap()
    {
        let span = MKCoordinateSpanMake(0.75, 0.75)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8339042, longitude: -88.0123418), span: span)
        mapView.setRegion(region, animated: true)
        
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId")! as UITableViewCell
    
        let busStop = self.busStops[indexPath.row]
        
        cell.textLabel?.text = busStop["cta_stop_name"] as? String
        
        cell.detailTextLabel!.text = busStop["routes"] as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busStops.count
    }
    
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if(pinView == nil){
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            //pinView!.pinTintColor = .Red
            
            let calloutButton = UIButton(type: .DetailDisclosure) as UIButton
            pinView!.rightCalloutAccessoryView = calloutButton
        } else {
            pinView!.annotation = annotation
        }
        return pinView!
    }
    
//this is the sguew fom the i button
    

    

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("Detail", sender: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destVC = segue.destinationViewController as! DetailViewController
        
        let pin = sender as! MKAnnotationView
        
        let clickeBusStopLongitudeDegrees = pin.annotation!.coordinate.longitude
        
        let clickedLongitudeString = "\(clickeBusStopLongitudeDegrees)"
        
        for busStop in busStops {
            if ((busStop["longitude"]?.isEqual(clickedLongitudeString)) != nil)  {
                destVC.busStop = busStop
            }
        }
    }
    



}





















































