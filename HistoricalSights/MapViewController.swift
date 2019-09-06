//
//  MapViewController.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 5/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    weak var databaseController: DatabaseProtocol?
    weak var coreDataController: CoreDataController?
    var fetchResultController: NSFetchedResultsController<Location>!
    var annotationList = [LocationAnnotation]()
    var locations: [Location] = []
    let initialLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
    let regionRadius : CLLocationDistance = 2000
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsTraffic = true
        mapView.showsScale = true
        mapView.showsCompass = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        showAnnotations()
    }
    func showAnnotations(){
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? CoreDataController) {
            let context = appDelegate.persistantContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    locations = fetchedObjects
                    for location in locations{
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(location.address ?? "") { (placemarks, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if let placemarks = placemarks {
                                // Get the first placemark
                                let placemark = placemarks[0]
                                let coordinate = placemark.location
                                let sight = LocationAnnotation(newTitle: location.title!, newSubtitle: location.subtitle!, coordinate: coordinate!.coordinate)
                                self.mapView.addAnnotation(sight)
                                
                                // Add annotation
                                /* let annotation = MKPointAnnotation()
                                 annotation.title = location.title
                                 annotation.subtitle = location.subtitle
                                 
                                 if let location = placemark.location {
                                 print(location.coordinate)
                                 annotation.coordinate = location.coordinate
                                 
                                 // Display the annotation
                                 self.mapView.addAnnotation(annotation)*/
                                //self.mapView.selectAnnotation(annotation, animated: true)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

