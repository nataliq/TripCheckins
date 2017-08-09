//
//  TripCheckinsTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class CheckinItemsParserTests: XCTestCase {
    
    let parser = CheckinItemsParser()
    let testTimestamp = Date().timeIntervalSince1970
    
    func testParsingCheckinItems() {
        let testResponse = [
            "meta": [
                "code": 200
            ],
            "response": ["checkins": ["items": [
                ["venue": ["name": "Test name 1", "location": ["city": "Dobrich"]], "createdAt": testTimestamp],
                ["venue": ["name": "Test name 2", "location": ["country": "Bulgaria"]], "createdAt": testTimestamp]
            ]]]
        ]
        let items = parser.itemsFromJSON(testResponse)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].locationName, "Dobrich")
        XCTAssertEqual(items[1].locationName, "Bulgaria")
        XCTAssertEqual(items[0].date.timeIntervalSince1970, testTimestamp)
    }
    
    func testParsingNotValidCheckinsResponse() {
        let testResponse = [
            "meta": [
                "code": 401
            ],
            "response": ["checkins": ["items": [
                ["venue": ["name": "Test name 1", "location": ["city": "Dobrich"]], "createdAt": testTimestamp],
                ["venue": ["name": "Test name 2", "location": ["country": "Bulgaria"]], "createdAt": testTimestamp]
                ]]]
        ]
        let items = parser.itemsFromJSON(testResponse)
        XCTAssertEqual(items.count, 0)
    }
    
    func testSkippingNotValidCheckinItems() {
        let testResponse = [
            "meta": [
                "code": 200
            ],
            "response": ["checkins": ["items": [
                ["venue": ["name": "Test name 1", "location": ["city": "Dobrich"]], "createdAt": testTimestamp],
                ["venue": ["name": "Test name 2", "location": ["country": "Bulgaria"]]]
                ]]]
        ]
        let items = parser.itemsFromJSON(testResponse)
        XCTAssertEqual(items.count, 1)
    }
}
