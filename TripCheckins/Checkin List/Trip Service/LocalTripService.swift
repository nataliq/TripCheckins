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
    
    init(localItemsStorage: LocalItemsStorage) {
        self.localItemsStorage = localItemsStorage
    }
    
    func loadAllTrips(_ completion: ([Trip]) -> Void) {
        let trips = localTrips()
        completion(trips)
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
