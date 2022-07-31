//
//  LocationCoreDataService.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import CoreData

protocol LocationFetchStorageService {
    func fetchAllLocations(completionHandler: @escaping (_ result: Result<[LocationItem], Error>) -> Void)
}

protocol LocationInsertStorageService {
    func insertLocation(_ item: LocationItem, completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void)
}

final class LocationCoreDataService: LocationFetchStorageService, LocationInsertStorageService {
    private let service: CoreDataService = .shared
    
    func fetchAllLocations(completionHandler: @escaping (Result<[LocationItem], Error>) -> Void) {
        let context: NSManagedObjectContext = service.viewContext
        context.perform {
            do {
                let request = Location.fetchRequest()
                let locations = try context.fetch(request)
                let locationItems: [LocationItem] = locations.compactMap { location in
                    guard let cityName = location.title else { return nil }
                    return LocationItem(title: cityName)
                }
                completionHandler(.success(locationItems))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    func insertLocation(_ item: LocationItem, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        service.persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            do {
                let location = Location(context: context)
                location.title = item.title
                if context.hasChanges {
                    try context.save()
                }
                completionHandler(.success(true))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
