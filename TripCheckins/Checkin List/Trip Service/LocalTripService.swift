//
//  LocalTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class LocalTripService: TripService {
    
    private var localItemsStorage: LocalItemsStorage
    private var additionalTripSource: TripService?
    private var additionalTrips: [Trip]?
    
    init(localItemsStorage: LocalItemsStorage, additionalTripSource: TripService? = nil) {
        self.localItemsStorage = localItemsStorage
        self.additionalTripSource = additionalTripSource
    }
    
    func loadAllTrips(_ completion: ([Trip]) -> Void) {
        let trips = localTrips()
        
        if let additionalTripSource = additionalTripSource, additionalTrips == nil {
            additionalTripSource.loadAllTrips({ [weak self] (additionalTrips) in
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
