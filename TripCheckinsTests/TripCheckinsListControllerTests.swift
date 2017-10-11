
//
//  TripCheckinsListControllerTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/14/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class TripCheckinsListControllerTests: XCTestCase {
    
    class TestCheckinService: CheckinService {
        var expectedLoadStartDate: Date!
        var expectedLoadEndDate: Date!
        
        let testItems: [CheckinItem] = [
            CheckinItem(venueName: "1", city: "", country: "", date: Date(), dateTimeZoneOffset: 0),
            CheckinItem(venueName: "2", city: "", country: "", date: Date(), dateTimeZoneOffset: 0)
        ]
        func loadCheckins(after fromDate: Date?,
                          before toDate: Date?,
                          completionHandler: @escaping ([CheckinItem]) -> Void) {
            assert(expectedLoadStartDate == fromDate)
            assert(expectedLoadEndDate == toDate)
            completionHandler(self.testItems)
        }
    }
    
    class TestTripService: TripService, ObserversContainer {
        lazy var observers: [WeakObserverReference] = []
        
        func addTrip(_ trip: Trip) { }
        var testTrips: [String:Trip]?
        func loadTrip(withId id: String, completionHandler completion: (Trip?) -> Void) {
            if let trip = testTrips?[id] {
                completion(trip)
            }
        }
        func loadAllTrips(_ completion: ([Trip]) -> Void) {
            if let testTrips = testTrips {
                completion(Array(testTrips.values))
            }
        }
    }
    
    var listController: TripCheckinsListController!
    let checkinService = TestCheckinService()
    let tripService = TestTripService()
    let tripId = "testTripId"
    let testTrip = Trip(startDate: Date().addingTimeInterval(-60), endDate: Date(), name: "test trip")
    
    override func setUp() {
        super.setUp()
        tripService.testTrips = [
            "other": Trip(startDate: Date(), endDate: nil, name: "other trip"),
            tripId: testTrip
        ]
        checkinService.expectedLoadStartDate = testTrip.startDate
        checkinService.expectedLoadEndDate = testTrip.endDate
        listController = TripCheckinsListController(checkinsService: checkinService, tripService: tripService, tripId: tripId)
    }
    
    func testThatCurrentViewModelIsNilBeforeReloadingItems() {
        XCTAssertNil(listController.currentListViewModel)
    }
    
    func testThatReloadingItemsWithoutUpdateBlockDoNotThorw() {
        XCTAssertNoThrow(listController.reloadListItems())
    }
    
    func testThatUpdateClosureIsCalledBeforeAndAfterTripLoadingAndThenWhenItemsAreLoaded() {
        let loadingStateWithoutTitleExpectation = expectation(description: "loading state without title")
        let loadingStateWithTitleExpectation = expectation(description: "loading state with title")
        let loadedStateExpectation = expectation(description: "items loaded")
        let noErrorStateExpectation = expectation(description: "no error state")
        noErrorStateExpectation.isInverted = true
        
        listController.onViewModelUpdate = {
            XCTAssertNotNil(self.listController.currentListViewModel)
            
            switch self.listController.currentListViewModel!.state {
            case .loadingItems:
                if self.listController.currentListViewModel!.title.isEmpty {
                    loadingStateWithoutTitleExpectation.fulfill()
                } else {
                    loadingStateWithTitleExpectation.fulfill()
                }
            case.error(_):
                noErrorStateExpectation.fulfill()
            case .loadedListItemViewModels(_):
                loadedStateExpectation.fulfill()
            }
        }
        
        listController.reloadListItems()
        wait(for: [loadingStateWithoutTitleExpectation,
                   loadingStateWithTitleExpectation,
                   loadedStateExpectation,
                   noErrorStateExpectation],
             timeout: 1,
             enforceOrder: true)
    }
    
    func testThatLoadingStateContainsTripTitle() {
        let loadingStateWithTitleExpectation = expectation(description: "loading state with title")
        
        listController.onViewModelUpdate = {
            switch self.listController.currentListViewModel!.state {
            case .loadingItems:
                if self.listController.currentListViewModel!.title == "test trip" {
                    loadingStateWithTitleExpectation.fulfill()
                }
            default:
                break
            }
        }
        
        listController.reloadListItems()
        wait(for: [loadingStateWithTitleExpectation], timeout: 1)
    }
    
    func testThatLoadedStateContainsItemsProvidedFromCheckinService() {
        let loadedStateExpectation = expectation(description: "items loaded")
        let testItems = self.checkinService.testItems
        
        listController.onViewModelUpdate = {
            switch self.listController.currentListViewModel!.state {
            case .loadedListItemViewModels(let itemViewModels):
                XCTAssertFalse(itemViewModels.isEmpty)
                XCTAssertEqual(itemViewModels.count, testItems.count)
                zip(itemViewModels, testItems).forEach({ (viewModel, item) in
                    XCTAssertEqual(viewModel.venueName, item.venueName)
                })
                loadedStateExpectation.fulfill()
            default:
                break
            }
        }
        
        listController.reloadListItems()
        wait(for: [loadedStateExpectation], timeout: 1)
    }
}
