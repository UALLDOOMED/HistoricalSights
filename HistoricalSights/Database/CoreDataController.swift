//
//  CoreDataController.swift
//  HistoricalSights
//
//  Created by Qiwei Wang on 5/9/19.
//  Copyright © 2019 Qiwei Wang. All rights reserved.
//

import UIKit
import CoreData
class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    var allLocationsFetchedResultsController: NSFetchedResultsController<Location>?
    override init() {
        persistantContainer = NSPersistentContainer(name: "HistoricalSights")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)") }
        }
        super.init()
        // If there are no heroes in the database assume that the app is running // for the first time. Create the default team and initial superheroes.
        if fetchAllLocations().count == 0 {
            createDefaultEntries()
            
        }
    }
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)") }
        } }
    func addLocation(title: String, subtitle: String, descriptions: String, address: String, image: String, icon: String) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into:
            persistantContainer.viewContext) as! Location
        location.title = title
        location.subtitle = subtitle
        location.descriptions = descriptions
        location.address = address
        location.image = image
        location.icon = icon
        // This less efficient than batching changes and saving once at end.
        saveContext()
        return location
    }
    func deleteLocation(location: Location) {
        persistantContainer.viewContext.delete(location)
         saveContext()
        // This less efficient than batching changes and saving once at end. saveContext()
    }
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == ListenerType.location || listener.listenerType == ListenerType.all {
            listener.onLocationChange(change: .update, locations:fetchAllLocations())
        }
    }
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener) }
    func fetchAllLocations() -> [Location] {
        if allLocationsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "title", ascending: true); fetchRequest.sortDescriptors = [nameSortDescriptor]
            allLocationsFetchedResultsController = NSFetchedResultsController<Location>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allLocationsFetchedResultsController?.delegate = self
            do {
                try allLocationsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        var locations = [Location]()
        if allLocationsFetchedResultsController?.fetchedObjects != nil {
            locations = (allLocationsFetchedResultsController?.fetchedObjects)!
        }
        return locations
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allLocationsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.location || listener.listenerType == ListenerType.all {
                    listener.onLocationChange(change: .update, locations: fetchAllLocations()) }
            } }
    }
    func createDefaultEntries() {
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Flinders Station", subtitle: "Historical Station", descriptions: "Beautiful Station", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
    }
}
