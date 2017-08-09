//
//  CheckinsDataSource.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class CheckinsDataSource {
    let fetcher: CheckinFetcher
    let parser: CheckinItemsParser
    
    private var items: [CheckinItem]?
    
    init(fetcher: CheckinFetcher, parser: CheckinItemsParser) {
        self.fetcher = fetcher
        self.parser = parser
    }
    
    func reloadItems(_ completion:@escaping () -> Void) {
        fetcher.fetch { (json) in
            self.items = self.parser.itemsFromJSON(json)
            completion()
        }
    }
    
    func numberOfItems() -> Int {
        return items?.count ?? 0
    }
    
    func itemForIndex(_ index: Int) -> CompactCheckinCellModel {
        return CompactCheckinCellModel(checkinItem: items![index])
    }
}
