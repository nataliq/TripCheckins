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
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: Date(), to: nil)
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("afterTimestamp"))
        XCTAssertFalse(url!.absoluteString.contains("beforeTimestamp"))
    }
    
    func testConstructingURLWithTokenAndToDate() {
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: nil, to: Date())
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("beforeTimestamp"))
        XCTAssertFalse(url!.absoluteString.contains("afterTimestamp"))
    }
    
    func testConstructingURLWithTokenAndFromDateAndToDate() {
        let url = FoursquareEndpointConstructor.checkinsURL(forUserToken: "token", from: Date(), to: Date())
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("oauth_token=token"))
        XCTAssertTrue(url!.absoluteString.contains("afterTimestamp"))
        XCTAssertTrue(url!.absoluteString.contains("beforeTimestamp"))
    }
}
