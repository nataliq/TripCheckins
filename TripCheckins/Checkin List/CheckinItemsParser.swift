//
//  CheckinItemsParser.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct CheckinItem {
    let venueName: String
    let locationName: String
    let date: Date
}

class CheckinItemsParser {
    
    func itemsFromJSON(_ json:[String:Any]) -> [CheckinItem] {
        
        guard let metaDictionary = json["meta"] as? [String: Any],
        let code = metaDictionary["code"] as? Int,
        code == 200 else {
            print("response code was not 200")
            return []
        }
        
        guard let responseDictionary = json["response"] as? [String: Any],
        let checkinsDictionary = responseDictionary["checkins"] as? [String: Any],
        let checkinItemDictionaries = checkinsDictionary["items"] as? [[String: Any]] else {
            print("unexpected checkins response format")
            return []
        }
        
        var items = [CheckinItem]()
        for checkinItemDictionary in checkinItemDictionaries {
            guard let venue = checkinItemDictionary["venue"] as? [String: Any],
                let venueName = venue["name"] as? String,
                let timestamp = checkinItemDictionary["createdAt"] as? TimeInterval,
                let venueLocation = venue["location"] as? [String: Any] else {
                    print("unexpected checkin item format")
                    continue
            }
            let date = Date(timeIntervalSince1970: timestamp)
            let locationName = venueLocation["city"] as? String ?? venueLocation["country"] as? String ?? ""
            
            items.append(CheckinItem(venueName: venueName, locationName: locationName, date: date))
        }
        return items
    }
}
