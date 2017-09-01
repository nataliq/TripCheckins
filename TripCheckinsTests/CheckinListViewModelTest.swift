//
//  CheckinListViewModelTest.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 9/1/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class CheckinListViewModelTest: XCTestCase {
    
    func testViewModelTitle() {
        let viewModel = CheckinListViewModel(title: "test", listItemViewsType: .normal, state: .loadingItems)
        XCTAssertEqual(viewModel.title, "test")
    }
    
    func testViewModelListItemViewsType() {
        let viewModel = CheckinListViewModel(title: "test", listItemViewsType: .compact, state: .loadingItems)
        XCTAssertEqual(viewModel.listItemViewsType, .compact)
    }
    
    func testNoListItemsWhenStateIsLoading() {
        let viewModel = CheckinListViewModel(title: "test", listItemViewsType: .normal, state: .loadingItems)
        XCTAssertEqual(viewModel.listItemsCount(), 0)
        XCTAssertNil(viewModel.listItemViewModel(at: 0))
    }
    
    func testNoListItemsWhenStateIsError() {
        let viewModel = CheckinListViewModel(title: "test", listItemViewsType: .normal, state: .error("error"))
        XCTAssertEqual(viewModel.listItemsCount(), 0)
        XCTAssertNil(viewModel.listItemViewModel(at: 0))
    }
    
    func testListItemsWhenStateIsLoadedItems() {
        let checkinItem = CheckinItem(venueName: "test", locationName: "test", date: Date())
        let listViewModel = CheckinListItemViewModel(checkinItem: checkinItem)
        let viewModel = CheckinListViewModel(title: "test",
                                             listItemViewsType: .normal,
                                             state: .loadedListItemViewModels([listViewModel]))
        XCTAssertEqual(viewModel.listItemsCount(), 1)
        XCTAssertNotNil(viewModel.listItemViewModel(at: 0))
    }
}
