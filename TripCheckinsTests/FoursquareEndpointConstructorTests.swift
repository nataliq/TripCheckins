//
//  FoursquareEndpointConstructorTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class FoursquareEndpointConstructorTests: XCTestCase {
    
    func testConstructingURLWithToken() {
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: nil, to: nil)
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("v=20170808"))
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertFalse(url!.absoluteString.contains("afterTimestamp"))
        XCTAssertFalse(url!.absoluteString.contains("beforeTimestamp"))
    }
    
    func testConstructingURLWithTokenAndFromDate() {
        let date = Date()
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: date, to: nil)
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("afterTimestamp=\(date.timeIntervalSince1970)"))
        XCTAssertFalse(url!.absoluteString.contains("beforeTimestamp"))
    }
    
    func testConstructingURLWithTokenAndToDate() {
        let date = Date()
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: nil, to: date)
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("beforeTimestamp=\(date.timeIntervalSince1970)"))
        XCTAssertFalse(url!.absoluteString.contains("afterTimestamp"))
    }
    
    func testConstructingURLWithTokenAndFromDateAndToDate() {
        let fromDate = Date()
        let toDate = fromDate.addingTimeInterval(60)
        
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: fromDate, to: toDate)
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("afterTimestamp=\(fromDate.timeIntervalSince1970)"))
        XCTAssertTrue(url!.absoluteString.contains("beforeTimestamp=\(toDate.timeIntervalSince1970)"))
    }
}
