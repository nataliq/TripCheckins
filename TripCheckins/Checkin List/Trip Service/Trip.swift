//
//  Trip.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/13/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct Trip: Codable {
    let uuid: String
    let startDate: Date?
    let endDate: Date?
    let name: String
    
    init(startDate: Date?, endDate: Date?, name: String) {
        self.uuid = UUID().uuidString
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
    }
}
