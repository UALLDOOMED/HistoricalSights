//
//  Location+CoreDataProperties.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 6/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var icon: String?
    @NSManaged public var image: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
