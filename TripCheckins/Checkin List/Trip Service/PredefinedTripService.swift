//
//  PredefinedTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/13/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class PredefinedTripService: TripService {
    func loadTrip(withId id: String, completionHandler completion:(Trip) -> Void) {
        let trip = Trip(startDate: Date().addingTimeInterval(-7*24*3600),
                        endDate: nil,
                        name: "Last 7 days")
        completion(trip)
    }
    
    func loadAllTrips(_ completion:([Trip]) -> Void) {
        let trips = [
            Trip(startDate: Date().addingTimeInterval(-7*24*3600),
                 endDate: nil,
                 name: "Last 7 days"),
            Trip(startDate: Date().addingTimeInterval(-7*24*3600),
                 endDate: nil,
                 name: "Last month"),
            Trip(startDate: Date().addingTimeInterval(-42*24*3600),
                 endDate: Date().addingTimeInterval(-11*24*3600),
                 name: "July, 2017")
        ]
        completion(trips)
    }
}
