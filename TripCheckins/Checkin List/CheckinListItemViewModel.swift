//
//  CompactCheckinCellViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct CheckinListItemViewModel {
    let venueName: String
    let locationName: String
    let dateString: String
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    init(checkinItem: CheckinItem) {
        self.venueName = checkinItem.venueName
        self.locationName = checkinItem.locationName
        self.dateString = CheckinListItemViewModel.dateFormatter.string(from: checkinItem.date)
    }
}
