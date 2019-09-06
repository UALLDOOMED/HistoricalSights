//
//  DatabaseProtocol.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 5/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//

enum DatabaseChange {
    case add
    case remove
    case update
    
}
enum ListenerType {
    case location
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onLocationChange(change: DatabaseChange, locations: [Location])
}
protocol DatabaseProtocol: AnyObject {
    func addLocation(title: String, subtitle: String, descriptions: String, address: String, image: String, icon: String, latitude: Double, longitude: Double) -> Location
    func deleteLocation(location: Location)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
