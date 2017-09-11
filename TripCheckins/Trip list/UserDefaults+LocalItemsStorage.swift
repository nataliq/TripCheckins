//
//  UserDefaults+LocalItemsStorage.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/27/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

let tripsKey = "trips"

extension UserDefaults: LocalItemsStorage {
    
    func storedTrips() -> [Trip] {
        
        let decoder = JSONDecoder()
        guard let tripsData = object(forKey: tripsKey) as? Data,
            let trips = try? decoder.decode([Trip].self, from: tripsData) else {
            return []
        }
        return trips
    }
    
    func storeTrip(_ trip: Trip) {
        var trips = storedTrips()
        trips.append(trip)
        
        let encoder = JSONEncoder()
        if let tripsData = try? encoder.encode(trips) {
            set(tripsData, forKey: tripsKey)
        }
    }
    
}
