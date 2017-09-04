//
//  CheckinItemsParser.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class FoursquareCheckinItemParser {
    
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
            let city = venueLocation["city"] as? String
            let country = venueLocation["country"] as? String
            let timeZoneOffset = checkinItemDictionary["timeZoneOffset"] as? Int ?? 0
            
            items.append(CheckinItem(venueName: venueName,
                                     city: city,
                                     country: country,
                                     date: date,
                                     dateTimeZoneOffset: timeZoneOffset))
        }
        return items
    }
}
