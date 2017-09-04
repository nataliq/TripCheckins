//
//  DateFilterViewModelTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 8/23/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class DateFilterViewModelTests: XCTestCase {
    
    func testThatMaximumEndDateIsAutomaticallySet() {
        let viewModel = DateFilterViewModel()
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeMaximumEndDate() {
        let viewModel = DateFilterViewModel()
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: viewModel.maximumEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatDateFilterDatesAreInitiallyNil() {
        let viewModel = DateFilterViewModel()
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertNil(viewModel.dateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testThatDateFilterDatesAreEqualToTheOnesProvidedIfValid() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        let viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        XCTAssertEqual(viewModel.dateFilter.startDate, testStartDate)
        XCTAssertEqual(viewModel.dateFilter.endDate, testEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testThatDateFilterStartDateIsAtLeastOneDayBeforeEndDate() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-1)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        let viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        XCTAssertNotEqual(viewModel.dateFilter.startDate, testStartDate)
        XCTAssertEqual(viewModel.dateFilter.endDate, testEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.dateFilter.startDate!,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatMaximumEndDateIsEqualToTheOneProvided() {
        let maximumEndDate = Date()
        let testDateFilter = DateFilter(startDate: nil, endDate: nil)
        let viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        XCTAssertEqual(viewModel.maximumEndDate, maximumEndDate)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeInitialDateFilterEndDate() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testDateFilter = DateFilter(startDate: nil, endDate: testEndDate)
        let viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testThatMaximumStartDateIsOneDayBeforeUpdatedDateFilterEndDate() {
        var viewModel = DateFilterViewModel()
        let testEndDate = Date().addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(testEndDate)
        
        let components = NSCalendar.current.dateComponents([.day],
                                                           from: viewModel.maximumStartDate,
                                                           to: testEndDate)
        XCTAssertEqual(components.day, 1)
    }
    
    func testUpdatingEndDateWithValidDate() {
        var viewModel = DateFilterViewModel()
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertEqual(viewModel.dateFilter.endDate, updatedTestEndDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testUpdatingEndDateWithNil() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        var viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        viewModel.updateEndDate(nil)
        
        XCTAssertNotNil(viewModel.dateFilter.startDate)
        XCTAssertNil(viewModel.dateFilter.endDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithValidDate() {
        var viewModel = DateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        
        XCTAssertEqual(viewModel.dateFilter.startDate, updatedTestStartDate)
        XCTAssertNil(viewModel.dateFilter.endDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithNil() {
        let maximumEndDate = Date()
        let testEndDate = maximumEndDate.addingTimeInterval(-2*24*3600)
        let testStartDate = testEndDate.addingTimeInterval(-4*24*3600)
        let testDateFilter = DateFilter(startDate: testStartDate, endDate: testEndDate)
        
        var viewModel = DateFilterViewModel(maximumEndDate: maximumEndDate, dateFilter: testDateFilter)
        viewModel.updateStartDate(nil)
        
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertNotNil(viewModel.dateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
    }
    
    func testUpdatingEndDateWithNotValidDate() {
        var viewModel = DateFilterViewModel()
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertNil(viewModel.dateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartDateWithNotValidDate() {
        var viewModel = DateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertNil(viewModel.dateFilter.endDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNil(viewModel.endDateString)
    }
    
    func testUpdatingStartAndEndDatesWithValidDates() {
        var viewModel = DateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-4*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertEqual(viewModel.dateFilter.startDate, updatedTestStartDate)
        XCTAssertEqual(viewModel.dateFilter.endDate, updatedTestEndDate)
        XCTAssertNotNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
    
    func testThatUpdatingEndDateWithDateBeforeCurrentStartDateSetsStartDateToNil() {
        var viewModel = DateFilterViewModel()
        let updatedTestStartDate = viewModel.maximumEndDate.addingTimeInterval(-2*24*3600)
        viewModel.updateStartDate(updatedTestStartDate)
        let updatedTestEndDate = viewModel.maximumEndDate.addingTimeInterval(-4*24*3600)
        viewModel.updateEndDate(updatedTestEndDate)
        
        XCTAssertNil(viewModel.dateFilter.startDate)
        XCTAssertEqual(viewModel.dateFilter.endDate, updatedTestEndDate)
        XCTAssertNil(viewModel.startDateString)
        XCTAssertNotNil(viewModel.endDateString)
        XCTAssertNotNil(viewModel.maximumEndDate)
    }
}
