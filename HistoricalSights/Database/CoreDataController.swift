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
        let _ = addLocation(title: "Flinders Station", subtitle: "Heritage buildings", descriptions: "Flinders Street railway station is a railway station on the corner of Flinders and Swanston Streets in Melbourne, Victoria, Australia. It serves the entire metropolitan rail network.", address: "Flinders St, Melbourne VIC 3000", image:"flinders-street-station_mel_r_1460109_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "St Paul's Cathedral", subtitle: "Heritage buildings", descriptions: "St Paul's Cathedral is an Anglican cathedral in Melbourne, Victoria, Australia. It is the cathedral church of the Diocese of Melbourne and the seat of the Archbishop of Melbourne, who is also the metropolitan archbishop of the Province of Victoria and, since 28 June 2014, the present seat of the Primate of Australia.", address: "Flinders Ln & Swanston St, Melbourne VIC 3000", image:"st-pauls-cathedral_mel_r_132569_1600x900", icon:"icons8-library-30")
        let _ = addLocation(title: "Old Melbourne Gaol", subtitle: "Heritage & History", descriptions: "The Old Melbourne Gaol is a museum on Russell Street, in Melbourne, Victoria, Australia. It consists of a bluestone building and courtyard, and is located next to the old City Police Watch House and City Courts buildings.", address: "377 Russell Street, Melbourne, Victoria, 3000", image:"Old_Melbourne_Gaol", icon:"icons8-building-30")
        let _ = addLocation(title: "The Forum", subtitle: "Live Music", descriptions: "Forum Melbourne is a live music, cinema, theatre, and event venue located on the corner of Flinders Street and Russell Street in Melbourne, Australia. Built in 1929, it was designed by leading US ‘picture palace’ architect John Eberson, in association with the local architectural firm Bohringer, Taylor & Johnson.", address: "154 Flinders Street, Melbourne, Victoria, 3000", image:"Image-46-1533083252", icon:"icons8-building-30")
        let _ = addLocation(title: "Royal Exhibition Building", subtitle: "Heritage buildings", descriptions: "The Royal Exhibition Building is a World Heritage Site-listed building in Melbourne, Australia, completed on October 1, 1880, in just 18 months, during the time of the international exhibition movement which presented over 50 exhibitions between 1851 and 1915 in various different places. ", address: "9 Nicholson St, Carlton VIC 3053", image:"royal-exhibition-building-autumn_mel_r_credit-roberto-seba_1413882_1900x600", icon:"icons8-library-30")
        let _ = addLocation(title: "Melbourne Museum", subtitle: "Museum", descriptions: "Melbourne Museum is a natural and cultural history museum located in the Carlton Gardens in Melbourne, Australia. Located adjacent to the Royal Exhibition Building, it is the largest museum in the Southern Hemisphere.", address: "11 Nicholson Street, Carlton, Victoria, 3053", image:"melbourne-museum-2019", icon:"icons8-library-30")
        let _ = addLocation(title: "Fire Services Museum of Victoria", subtitle: "Museum", descriptions: "Eastern Hill Fire Station is the central fire station of Melbourne, Victoria, located on the corner of Victoria Parade and Gisborne Street at one of the highest points in the City", address: "39 Gisborne Street, East Melbourne, Victoria, 3002", image:"fire-service-museum", icon:"icons8-library-30")
        let _ = addLocation(title: "The Australian Music Vault", subtitle: "Museum", descriptions: "The Australian Music Vault, developed by Arts Centre Melbourne in consultation with the music industry, is a celebration of the Australian contemporary music story – past, present and future.It’s a place to explore your love of music, revisit some of the big music moments of your life and discover the exciting new stories of today’s Australian music scene.", address: "100 St Kilda Road, Arts Centre Melbourne, Melbourne, Victoria, 3000", image:"music-vault", icon:"icons8-library-30")
        let _ = addLocation(title: "Chinese Museum", subtitle: "Museum", descriptions: "The Chinese Museum or Museum of Chinese Australian History is an Australian history museum located in Melbourne's Chinatown. The museum was established in 1985 with a charter to present the history of Australians of Chinese ancestry. An extensive refurbishment funded by the Victorian Government was completed in 2010.", address: "22 Cohen Place, Melbourne, Victoria, 3000", image:"Dragon-Gallery", icon:"icons8-library-30")
        let _ = addLocation(title: "Melbourne Convention and Exhibition Centre", subtitle: "Architecture & Design", descriptions: "The Melbourne Convention and Exhibition Centre is the name given to three adjacent buildings next to the Yarra River in South Wharf, an inner-city suburb of Melbourne, Victoria, Australia. The venues are owned and operated by the Melbourne Convention and Exhibition Trust.", address: "1 Convention Centre Place, South Wharf, Melbourne, Victoria, 3000", image:"Melbourne-Convention-and-Exhibition-Centre", icon:"icons8-flatiron-building-30")
        let _ = addLocation(title: "Southern Cross railway station", subtitle: "Landmark", descriptions: "Southern Cross railway station is a major railway station in Docklands, Melbourne. It is on Spencer Street, between Collins and La Trobe Streets, at the western edge of the central business district. The Docklands Stadium sports arena is 500 metres north-west of the station.", address: "Spencer St, Docklands VIC 3008", image:"southern-cross-station_mel_r_131129_1600x900", icon:"icons8-flatiron-building-30")
        let _ = addLocation(title: "NGV International", subtitle: "Art Gallery", descriptions: "The National Gallery of Victoria, popularly known as the NGV, is an art museum in Melbourne, Victoria, Australia. Founded in 1861, it is Australia's oldest, largest and most visited art museum.", address: "180 St Kilda Road, Melbourne, Victoria, 3000", image:"NGV-Melbourne", icon:"icons8-flatiron-building-30")
        let _ = addLocation(title: "Australian Centre for Contemporary Art", subtitle: "Art Gallery", descriptions: "The Australian Centre For Contemporary Art is a contemporary art gallery in Melbourne, Australia. The gallery is located on Sturt Street in the Melbourne Arts Precinct, in the inner suburb of Southbank. Designed by Wood Marsh Architects, the building was completed in 2002.", address: "111 Sturt Street, Southbank, Victoria, 3006", image:"Contemporary-Art", icon:"icons8-flatiron-building-30")
        let _ = addLocation(title: "Como House and Garden", subtitle: "Heritage & History", descriptions: "Como House is a historical house, with associated gardens in the City of Stonnington, Victoria, Australia. It was constructed in 1847 for Sir Edward Eyre Williams, and now serves as a tourist attraction under the custodianship of the National Trust of Australia.", address: "Williams Rd & Lechlade Ave, South Yarra VIC 3141", image:"como-house", icon:"icons8-building-30")
        let _ = addLocation(title: "St Patrick's Cathedral", subtitle: "Heritage Building", descriptions: "The Cathedral Church and Minor Basilica of Saint Patrick is the cathedral church of the Roman Catholic Archdiocese of Melbourne in Victoria, Australia, and seat of its archbishop, currently Peter Comensoli. In 1974 Pope Paul VI conferred the title and dignity of minor basilica on it.", address: "1 Cathedral Place, East Melbourne, Victoria, 3002", image:"St-Patrick's-Cathedral", icon:"icons8-library-30")
    }
}
