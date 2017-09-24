//
//  LocalTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class LocalTripService: TripService {
    
    private let tripsKey = "trips"
    private var localItemsStorage: LocalItemsStorage
    private var additionalTripLoadingService: TripLoadingService?
    private var additionalTrips: [Trip]?
    
    // TODO: keep weak references
    private lazy var observers: [AnyObject & Observer] = []
    
    init(localItemsStorage: LocalItemsStorage, additionalTripLoadingService: TripLoadingService? = nil) {
        self.localItemsStorage = localItemsStorage
        self.additionalTripLoadingService = additionalTripLoadingService
    }
    
    func loadAllTrips(_ completion: ([Trip]) -> Void) {
        let trips = localTrips()
        
        if let additionalTripLoadingService = additionalTripLoadingService, additionalTrips == nil {
            additionalTripLoadingService.loadAllTrips({ [weak self] (additionalTrips) in
                self?.additionalTrips = additionalTrips
                completion(trips + additionalTrips)
            })
        } else {
            completion(trips + (additionalTrips ?? []))
        }
    }
    
    func addTrip(_ trip: Trip) {
        var trips = localTrips()
        trips.append(trip)
        
        let encoder = JSONEncoder()
        if let tripsData = try? encoder.encode(trips) {
            localItemsStorage.set(tripsData, forKey: tripsKey)
        }
        self.observers.forEach { $0.didUpdateObservableObject(self) }
    }
    
    private func localTrips() -> [Trip] {
        let decoder = JSONDecoder()
        guard let tripsData = localItemsStorage.object(forKey: tripsKey) as? Data,
            let trips = try? decoder.decode([Trip].self, from: tripsData) else {
                return []
        }
        return trips
    }
    
    // MARK: - Observable
    func addObserver(_ observer: AnyObject & Observer) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: AnyObject & Observer) {
        _ = observers.index(where: { $0 === observer }).flatMap { observers.remove(at: $0) }
    }
    
}
