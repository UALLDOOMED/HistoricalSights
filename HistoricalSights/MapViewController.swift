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
class MapViewController: UIViewController, DatabaseListener, MKMapViewDelegate, NSFetchedResultsControllerDelegate{
    var listenerType = ListenerType.location
    
    func onLocationChange(change: DatabaseChange, locations: [Location]) {
        self.locations = locations
    }
    

    @IBOutlet weak var mapView: MKMapView!
    weak var databaseController: DatabaseProtocol?
    var fetchResultController: NSFetchedResultsController<Location>!
    var annotationList = [LocationAnnotation]()
    var locations: [Location] = []
    var location: Location!
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
    }
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        mapView.register(AnnotationMarkerView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        databaseController?.addListener(listener: self)
        for location in locations{
            let annotation = LocationAnnotation(newTitle: location.title!, newSubtitle: location.subtitle!, latitude: location.latitude, longitude: location.longitude,icon: location.icon!)

            self.mapView.addAnnotation(annotation)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
extension MapViewController{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        guard let annotation = annotation as? LocationAnnotation else { return nil }
      
        let identifier = "marker"
        var view: MKMarkerAnnotationView
       
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
           
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

