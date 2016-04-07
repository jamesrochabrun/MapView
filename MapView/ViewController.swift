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
    //allows to know where the user is
    let locationManager = CLLocationManager()
    

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
        
        //user Privacy
        self.locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        //changing the color of the annotation button
        mapView.tintColor = UIColor.brownColor()
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
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8339042, longitude: -88.0123418), span: span)
        mapView.setRegion(region, animated: true)
        
    }

//tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId")! as UITableViewCell
    
        let busStop = self.busStops[indexPath.row]
        
        cell.textLabel?.text = busStop["cta_stop_name"] as? String
        
        cell.detailTextLabel!.text = busStop["routes"] as? String
        
        if(busStop["inter_modal"] as? String) == "Pace"
        {
            cell.imageView?.image = UIImage(named: "smallBus")
        } else if (busStop["inter_modal"] as? String) == "Pace" {
            cell.imageView?.image = UIImage(named: "otherpic")
        }
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busStops.count
    }
    
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //userlocation
        if annotation is MKUserLocation{
            return nil
        }
        
        
           let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named:"smallBus")
            pinView.canShowCallout = true
//            pinView.animatesDrop = true
//            pinView.pinColor = .Green
        
            let calloutButton = UIButton(type: .DetailDisclosure) as UIButton
            pinView.rightCalloutAccessoryView = calloutButton

    
        return pinView
    }
    
    

    //fix for create a segue form the i button, also we need to drag the donut fromm the VC to the other vC
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("DetailFromMap", sender: view)
    }
    
    
    
//toggle between segues to destination from tableview and from mapView
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "DetailFromMap" {
        
        let destVC = segue.destinationViewController as! DetailViewController
        
        let pin = sender as! MKAnnotationView
            
        let clickedBusStopLongitudeDegrees = pin.annotation!.coordinate.longitude
            
        let clickedBusStopLatitudeDegrees = pin.annotation!.coordinate.latitude

        let clickedLatitudeString = "\(clickedBusStopLatitudeDegrees)"
        
        let clickedLongitudeString = "\(clickedBusStopLongitudeDegrees)"
        
        for busStop in busStops {
            if (busStop["longitude"] as! String == clickedLongitudeString && busStop["latitude"] as! String ==  clickedLatitudeString)  {
                destVC.busStop = busStop
//                print(destVC.busStop)
            }
        }//fin for loop
            
         destVC.isMapDetail = true
        }
        else{
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let busStop = self.busStops[indexPath!.row]

            let destVC = segue.destinationViewController as! DetailViewController
            
            //passing the dictionary to the next VC 
            destVC.busStop = busStop
            destVC.isMapDetail = false

        }
        
    }
    



}





















































