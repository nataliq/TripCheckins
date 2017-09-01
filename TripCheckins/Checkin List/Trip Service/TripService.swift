//
//  TripLoader.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol TripService {
    func loadTrip(withId id: String, completionHandler completion:(Trip) -> Void)
    func loadAllTrips(_ completion:([Trip]) -> Void)
}
