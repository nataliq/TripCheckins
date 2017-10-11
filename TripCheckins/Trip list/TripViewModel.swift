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
        
        var durationString = "All checkins"
        if let startDate = trip.startDate, let endDate = trip.endDate {
            durationString = "\(DateFormatter.tripDateFormatter.string(from: startDate)) - \(DateFormatter.tripDateFormatter.string(from: endDate))"
        } else if let startDate = trip.startDate {
            durationString = "After \(DateFormatter.tripDateFormatter.string(from: startDate))"
        } else if let endDate = trip.endDate {
            durationString = "Before \(DateFormatter.tripDateFormatter.string(from: endDate))"
        }
        
        self.durationString = durationString
    }
}
