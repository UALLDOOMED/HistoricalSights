//
//  LocationAnnotation.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 6/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//

import UIKit
import MapKit
class LocationAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var icon: String?
    var markerTintColor: UIColor  {
        switch icon {
        case "icons8-building-30":
            return .red
        case "icons8-flatiron-building-30":
            return .cyan
        case "icons8-library-30":
            return .blue
        case "icons8-skyscrapers-30":
            return .purple
        default:
            return .green
        }
    }
    init(newTitle: String, newSubtitle: String, latitude: Double, longitude:Double, icon:String) {
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.icon = icon
        
        super.init()
    }
}
import MapKit

class AnnotationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let annotaion = newValue as? LocationAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = annotaion.markerTintColor
        }
    }
}
