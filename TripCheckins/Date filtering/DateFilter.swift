//
//  DateFilter.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/17/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

public struct DateFilter {
    let startDate: Date?
    let endDate: Date?
    
    init(startDate: Date?, endDate: Date?) {
        if let startDate = startDate, let endDate = endDate {
            assert(startDate < endDate)
        }
        self.startDate = startDate
        self.endDate = endDate
    }
}
