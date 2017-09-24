//
//  PredefinedTripService.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/13/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class PredefinedTripService: TripLoadingService {

    func loadAllTrips(_ completion:([Trip]) -> Void) {
        let now = Date()
        
        var lastWeekComponents = DateComponents()
        lastWeekComponents.day = -7
        
        var lastMonthComponents = DateComponents()
        lastMonthComponents.month = -1
        
        var lastYearComponents = DateComponents()
        lastYearComponents.year = -1
        let lastYearOnThisDay = Calendar.current.date(byAdding: lastYearComponents, to: now)!
        
        let trips = [
            Trip(startDate: Calendar.current.date(byAdding: lastWeekComponents, to: now)!,
                 endDate: nil,
                 name: "Last week"),
            Trip(startDate: Calendar.current.date(byAdding: lastMonthComponents, to: now)!,
                 endDate: nil,
                 name: "Last month"),
            Trip(startDate: lastYearOnThisDay,
                 endDate: lastYearOnThisDay.addingTimeInterval(24*3600),
                 name: "This day, 1 year ago")
        ]
        completion(trips)
    }
}
