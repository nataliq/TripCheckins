//
//  TripDateFormatter.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let tripDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
