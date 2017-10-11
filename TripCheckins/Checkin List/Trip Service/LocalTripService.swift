//
//  LocalTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class LocalTripService: TripService, ObserversContainer {
    
    private let tripsKey = "trips"
    private var localItemsStorage: LocalItemsStorage
    private var additionalTripLoadingService: TripLoadingService?
    private var additionalTrips: [Trip]?
    
    lazy var observers: [WeakObserverReference] = [WeakObserverReference]()
    
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
        notifyObservers()
    }
    
    private func localTrips() -> [Trip] {
        let decoder = JSONDecoder()
        guard let tripsData = localItemsStorage.object(forKey: tripsKey) as? Data,
            let trips = try? decoder.decode([Trip].self, from: tripsData) else {
                return []
        }
        return trips
    }
}
