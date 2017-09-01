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
        let testItems: [CheckinItem] = [
            CheckinItem(venueName: "1", locationName: "", date: Date()),
            CheckinItem(venueName: "2", locationName: "", date: Date())
        ]
        func loadCheckins(after fromDate: Date?, before toDate: Date?, completionHandler: @escaping ([CheckinItem]) -> Void) {
            completionHandler(self.testItems)
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
}
