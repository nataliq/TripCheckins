//
//  AllCheckinsListControllerTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/14/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class AllCheckinsListControllerTests: XCTestCase {
    
    class TestCheckinService: CheckinService {
        var testItems: [CheckinItem] = [
            CheckinItem(venueName: "1", locationName: "", date: Date()),
            CheckinItem(venueName: "2", locationName: "", date: Date())
        ]
        func loadCheckins(after fromDate: Date?, before toDate: Date?, completionHandler: @escaping ([CheckinItem]) -> Void) {
            let dateFilter = DateFilter(startDate: fromDate, endDate: toDate)
            completionHandler(self.testItems.filter(withDateFilter: dateFilter))
        }
    }
    
    var listController: AllCheckinsListController!
    let checkinService = TestCheckinService()
    
    override func setUp() {
        super.setUp()
        listController = AllCheckinsListController(checkinsService: checkinService)
    }
    
    func testThatCurrentViewModelIsNilBeforeReloadingItems() {
        XCTAssertNil(listController.currentListViewModel)
    }

    func testThatReloadingItemsWithoutUpdateBlockDoNotThorw() {
        XCTAssertNoThrow(listController.reloadListItems())
    }
    
    func testThatUpdateClosureIsCalledWhenLoadingStartsAndThenWhenItemsAreLoaded() {
        let loadingStateExpectation = expectation(description: "loading state")
        let loadedStateExpectation = expectation(description: "items loaded")
        let noErrorStateExpectation = expectation(description: "no error state")
        noErrorStateExpectation.isInverted = true
        
        listController.onViewModelUpdate = {
            XCTAssertNotNil(self.listController.currentListViewModel)
            
            switch self.listController.currentListViewModel!.state {
            case .loadingItems:
                loadingStateExpectation.fulfill()
            case.error(_):
                noErrorStateExpectation.fulfill()
            case .loadedListItemViewModels(_):
                loadedStateExpectation.fulfill()
            }
        }
        
        listController.reloadListItems()
        wait(for: [loadingStateExpectation, loadedStateExpectation, noErrorStateExpectation],
             timeout: 1,
             enforceOrder: true)
    }
    
    func testThatLoadedStateContainsItemsProvidedFromCheckinService() {
        let loadedStateExpectation = expectation(description: "loaded state")
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
    
    func testDateFiltering() {
        let now = Date()
        let item1Date = now.addingTimeInterval(-3)
        let item2Date = now.addingTimeInterval(-1)
        checkinService.testItems = [
            CheckinItem(venueName: "1", locationName: "", date: item1Date),
            CheckinItem(venueName: "2", locationName: "", date: item2Date)
        ]
        
        reloadItemsAndWaitForLoadedState()
        
        filterListControllr(fromDate: nil, toDate: nil) { items in
            XCTAssertTrue(items.contains(where: {$0.venueName == "1"}))
            XCTAssertTrue(items.contains(where: {$0.venueName == "2"}))
        }
    
        filterListControllr(fromDate: now.addingTimeInterval(-2), toDate: nil) { items in
            XCTAssertFalse(items.contains(where: {$0.venueName == "1"}))
            XCTAssertTrue(items.contains(where: {$0.venueName == "2"}))
        }
        
        filterListControllr(fromDate: nil, toDate: now.addingTimeInterval(-3)) { items in
            XCTAssertTrue(items.contains(where: {$0.venueName == "1"}))
            XCTAssertFalse(items.contains(where: {$0.venueName == "2"}))
        }
        
        filterListControllr(fromDate: now.addingTimeInterval(-3), toDate: now.addingTimeInterval(-2)) { items in
            XCTAssertTrue(items.contains(where: {$0.venueName == "1"}))
            XCTAssertFalse(items.contains(where: {$0.venueName == "2"}))
        }
        
        filterListControllr(fromDate: now.addingTimeInterval(-2), toDate: now.addingTimeInterval(-1)) { items in
            XCTAssertFalse(items.contains(where: {$0.venueName == "1"}))
            XCTAssertTrue(items.contains(where: {$0.venueName == "2"}))
        }
        
        filterListControllr(fromDate: now.addingTimeInterval(-5), toDate: now.addingTimeInterval(-4)) { items in
            XCTAssertFalse(items.contains(where: {$0.venueName == "1"}))
            XCTAssertFalse(items.contains(where: {$0.venueName == "2"}))
        }
    }
    
    // MARK: - Helpers
    func reloadItemsAndWaitForLoadedState() {
        let loadedStateExpectation = expectation(description: "loaded state")
        listController.onViewModelUpdate = {
            switch self.listController.currentListViewModel!.state {
            case .loadedListItemViewModels(_):
                loadedStateExpectation.fulfill()
            default:
                break
            }
        }
        
        listController.reloadListItems()
        wait(for: [loadedStateExpectation], timeout: 1)
        listController.onViewModelUpdate = nil
    }
    
    func filterListControllr(fromDate startDate:Date?, toDate endDate: Date?, loadedItemsAssertion assertion:([CheckinListItemViewModel]) -> Void) {
        let dateFilter = DateFilter(startDate: startDate, endDate: endDate)
        listController.filter(withDateFilter: dateFilter)
        XCTAssertNotNil(listController.currentListViewModel)
        switch listController.currentListViewModel!.state {
        case .loadedListItemViewModels(let items):
            assertion(items)
        default:
            XCTFail()
        }
    }
}
