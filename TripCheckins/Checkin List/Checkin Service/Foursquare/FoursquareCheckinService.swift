//
//  CheckinsDataSource.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class FoursquareCheckinService: CheckinService {
    func loadCheckins(after fromDate: Date? = nil,
                      before toDate: Date? = nil,
                      completionHandler completion: @escaping ([CheckinItem]) -> Void) {
        fetcher.fetch(from: fromDate, to: toDate, withCompletion: { [weak self] (json) in
            guard let strongSelf = self else { return }
            let items = strongSelf.parser.itemsFromJSON(json)
            DispatchQueue.main.async {
                completion(items)
            }
        })
    }
    
    let fetcher: FoursquareCheckinFetcher
    let parser: FoursquareCheckinItemParser
    
    init(fetcher: FoursquareCheckinFetcher, parser: FoursquareCheckinItemParser) {
        self.fetcher = fetcher
        self.parser = parser
    }
}
