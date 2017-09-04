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
        formatter.dateFormat = "MMM d 'at' h:mm a"
        return formatter
    }()
    
    init(checkinItem: CheckinItem) {
        self.venueName = checkinItem.venueName
        self.locationName = checkinItem.city ?? checkinItem.country ?? ""
        
        let dateFormatter = CheckinListItemViewModel.dateFormatter
        dateFormatter.timeZone = TimeZone(secondsFromGMT: checkinItem.dateTimeZoneOffset)
        self.dateString = dateFormatter.string(from: checkinItem.date)
    }
}
