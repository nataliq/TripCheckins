//
//  DateFilterViewModelTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/23/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class AddTripDateFilterViewModelTests: XCTestCase {
    
    func testThatMaximumEndDateIsAutomaticallySet() {
        let viewModel = AddTripDateFilterViewModel()
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeMaximumEndDate() {
        let viewModel = AddTripDateFilterViewModel()
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: viewModel.maximumEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatDateFilterDatesAreInitiallyNil() {
        let viewModel = AddTripDateFilterViewModel()
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertNil(viewModel.currentDateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testThatDateFilterDatesAreEqualToTheOnesProvidedIfValid() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        let viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        XCTAssertEqual(viewModel.currentDateFilter.startDate, testStartDate)
        XCTAssertEqual(viewModel.currentDateFilter.endDate, testEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testThatDateFilterStartDateIsAtLeastOneDayBeforeEndDate() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-1)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        let viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        XCTAssertNotEqual(viewModel.currentDateFilter.startDate, testStartDate)
        XCTAssertEqual(viewModel.currentDateFilter.endDate, testEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.currentDateFilter.startDate!,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatMaximumEndDateIsEqualToTheOneProvided() {
        let maximumEndDate = Date()
        let testDateFilter = DateFilter(startDate: nil, endDate: nil)
        let viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        XCTAssertEqual(viewModel.maximumEndDate, maximumEndDate)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeInitialDateFilterEndDate() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testDateFilter = DateFilter(startDate: nil, endDate: testEndDate)
        let viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeUpdatedDateFilterEndDate() {
        var viewModel = AddTripDateFilterViewModel()
        let testEndDate = Date().addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(testEndDate)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testUpdatingEndDateWithValidDate() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertEqual(viewModel.currentDateFilter.endDate, updatedTestEndDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testUpdatingEndDateWithNil() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        var viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        viewModel.updateEndDate(nil)
        
        XCTAssertNotNil(viewModel.currentDateFilter.startDate)
        XCTAssertNil(viewModel.currentDateFilter.endDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithValidDate() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        
        XCTAssertEqual(viewModel.currentDateFilter.startDate, updatedTestStartDate)
        XCTAssertNil(viewModel.currentDateFilter.endDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithNil() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        var viewModel = AddTripDateFilterViewModel(maximumEndDate: maximumEndDate,
                                                   currentDateFilter: testDateFilter)
        viewModel.updateStartDate(nil)
        
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertNotNil(viewModel.currentDateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testUpdatingEndDateWithNotValidDate() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertNil(viewModel.currentDateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithNotValidDate() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertNil(viewModel.currentDateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartAndEndDatesWithValidDates() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-4*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertEqual(viewModel.currentDateFilter.startDate, updatedTestStartDate)
        XCTAssertEqual(viewModel.currentDateFilter.endDate, updatedTestEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
    
    func testThatUpdatingEndDateWithDateBeforeCurrentStartDateSetsStartDateToNil() {
        var viewModel = AddTripDateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-4*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.currentDateFilter.startDate)
        XCTAssertEqual(viewModel.currentDateFilter.endDate, updatedTestEndDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
}
