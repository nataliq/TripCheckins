//
//  TripViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/27/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct TripViewModel {
    let title: String
    let durationString: String
    
    init(trip: Trip) {
        self.title = trip.name
        
        var durationString = "From " + DateFormatter.tripDateFormatter.string(from: trip.startDate)
        if let endDate = trip.endDate {
            durationString += " to " + DateFormatter.tripDateFormatter.string(from: endDate)
        }
        self.durationString = durationString
    }
}
