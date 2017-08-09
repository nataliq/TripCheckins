//
//  CheckinsDataSourceTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class CheckinsDataSourceTests: XCTestCase {
    
    var dataSource: CheckinsDataSource!
    
    override func setUp() {
        super.setUp()
        
        class TestFetcher: CheckinFetcher {
            override func fetch(with completion: @escaping ([String : Any]) -> Void) {
                completion([:])
            }
        }
        
        class TestParser: CheckinItemsParser {
            override func itemsFromJSON(_ json: [String : Any]) -> [CheckinItem] {
                return [
                    CheckinItem(venueName: "1", locationName: "", date: Date()),
                    CheckinItem(venueName: "2", locationName: "", date: Date())
                ]
            }
        }
        
        dataSource = CheckinsDataSource(fetcher: TestFetcher(authorizationToken: "token"), parser: TestParser())
    }
    
    func testBeforeFetchingItems() {
        XCTAssertEqual(dataSource.numberOfItems(), 0)
    }
    
    func testAfterFetchingItems() {
        let reloadExpectation = expectation(description: "reloading items")
        dataSource.reloadItems { reloadExpectation.fulfill() }
        wait(for: [reloadExpectation], timeout: 0.1)
        
        XCTAssertEqual(dataSource.numberOfItems(), 2)
        XCTAssertEqual(dataSource.itemForIndex(0).venueName, "1")
        XCTAssertEqual(dataSource.itemForIndex(1).venueName, "2")
    }
}
