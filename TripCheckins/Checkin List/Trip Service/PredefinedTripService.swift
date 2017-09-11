//
//  PredefinedTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/13/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class PredefinedTripService: TripService {
    
    func addTrip(_ trip: Trip) {
        assertionFailure("That's a predefined trip service, can't add additional trips")
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
