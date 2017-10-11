//
//  TripLoader.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

typealias TripService = TripLoadingService & TripCreationService

protocol TripLoadingService {
    func loadTrip(withId id: String, completionHandler completion:(Trip?) -> Void)
    func loadAllTrips(_ completion:([Trip]) -> Void)
}

protocol TripCreationService: Observable {
    func addTrip(_ trip: Trip)
    func addTrips(_ trips:[Trip])
}

extension TripLoadingService {
    func loadTrip(withId id: String, completionHandler completion: (Trip?) -> Void) {
        loadAllTrips { (trips) in
            completion(trips.filter { $0.uuid == id }.first)
        }
    }
}

extension TripCreationService {
    func addTrips(_ trips:[Trip]) -> Void {
        trips.forEach { addTrip($0) }
    }
}
