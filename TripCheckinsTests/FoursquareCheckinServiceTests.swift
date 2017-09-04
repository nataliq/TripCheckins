//
//  CheckinsDataSourceTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class FoursquareCheckinServiceTests: XCTestCase {
    
    var foursquareCheckinService: CheckinService!
    
    override func setUp() {
        super.setUp()
        
        class TestFetcher: FoursquareCheckinFetcher {
            override func fetch(from fromDate: Date?,
                                to toDate: Date?,
                                withCompletion completion: @escaping ([String : Any]) -> Void) {
                completion(["items": ["1", "2"]])
            }
        }
        
        class TestParser: FoursquareCheckinItemParser {
            override func itemsFromJSON(_ json: [String : Any]) -> [CheckinItem] {
                return (json["items"] as! [String]).map({ (name) -> CheckinItem in
                    return CheckinItem(venueName: name, city: "", country: "", date: Date(), dateTimeZoneOffset: 0)
                })
            }
        }
        
        foursquareCheckinService = FoursquareCheckinService(fetcher: TestFetcher(authorizationToken: "token"), parser: TestParser())
    }
    
    func testThatCompletionIsCalledWithFetchedAndParsedItems() {
        let reloadExpectation = expectation(description: "reloading items")
        
        var loadedItems: [CheckinItem] = []
        foursquareCheckinService.loadCheckins(after: nil, before: nil) { (items) in
            loadedItems = items
            reloadExpectation.fulfill()
        }
        
        wait(for: [reloadExpectation], timeout: 1)
        
        XCTAssertEqual(loadedItems.count, 2)
        XCTAssertEqual(loadedItems[0].venueName, "1")
        XCTAssertEqual(loadedItems[1].venueName, "2")
    }
}
