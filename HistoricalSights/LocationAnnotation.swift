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
    
    init(newTitle: String, newSubtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = newTitle
        self.subtitle = newSubtitle
        self.coordinate = coordinate
    }
}
