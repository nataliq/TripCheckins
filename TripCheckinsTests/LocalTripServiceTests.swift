//
//  LocalTripServiceTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 9/7/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

extension Dictionary: LocalItemsStorage {
    public func object(forKey defaultName: String) -> Any? {
        return self[defaultName as! Dictionary.Key]
    }
    
    public mutating func set(_ value: Any?, forKey defaultName: String) {
        self[defaultName as! Dictionary.Key] = value as? Dictionary.Value
    }
}

class LocalTripServiceTests: XCTestCase {
    
    let localItemsStorage = [String:Any]()
    var tripService: LocalTripService!
    
    override func setUp() {
        super.setUp()
        tripService = LocalTripService(localItemsStorage: localItemsStorage)
    }
    
    func testThatThereAreNoTripsBeforeAddingATrip() {
        var tripsCount = -1
        loadTrips(loadedTripsCount: &tripsCount)
        XCTAssertEqual(tripsCount, 0)
    }
    
    func testThatThereAreTripsAfterAddingATrip() {
        let trip = Trip(startDate: Date(), endDate: nil, name: "test")
        tripService.addTrip(trip)
        
        var tripsCount = -1
        loadTrips(loadedTripsCount: &tripsCount)
        XCTAssertEqual(tripsCount, 1)
    }
    
    func testGettingASpecificAddedTrip() {
        let trip = Trip(startDate: Date(), endDate: nil, name: "test")
        tripService.addTrip(trip)
        let loadingExpectation = expectation(description: "loading trips")
        tripService.loadTrip(withId: trip.uuid, completionHandler: { (trip) in
            XCTAssertNotNil(trip)
            loadingExpectation.fulfill()
        })
        wait(for: [loadingExpectation], timeout: 1)
    }
    
    func testGettingNilIfQueryingForANonExistingTrip() {
        let trip = Trip(startDate: Date(), endDate: nil, name: "test")
        tripService.addTrip(trip)
        let loadingExpectation = expectation(description: "loading trips")
        tripService.loadTrip(withId: trip.uuid + "a", completionHandler: { (trip) in
            XCTAssertNil(trip)
            loadingExpectation.fulfill()
        })
        wait(for: [loadingExpectation], timeout: 1)
    }
    
    private func loadTrips(loadedTripsCount count: inout Int) {
        let loadingExpectation = expectation(description: "loading trips")
        tripService.loadAllTrips { trips in
            count = trips.count
            loadingExpectation.fulfill()
        }
        wait(for: [loadingExpectation], timeout: 1)
    }
    
}
