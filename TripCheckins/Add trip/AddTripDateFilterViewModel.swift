//
//  DateFilterViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/17/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol DateFilterCreationViewModel: DateFilterProvider {
    var maximumStartDate: Date { get }
    var maximumEndDate: Date { get }
    var startDateString: String? { get }
    var endDateString: String? { get }
    
    mutating func updateStartDate(_ endDate: Date?)
    mutating func updateEndDate(_ endDate: Date?)
}

public struct AddTripDateFilterViewModel: DateFilterCreationViewModel {

    private(set) var currentDateFilter: DateFilter {
        didSet {
            maximumStartDate = calculatedMaximumStartDate()
        }
    }

    private(set) var maximumStartDate: Date
    let maximumEndDate: Date

    var startDateString: String? {
        return formattedDateString(for: currentDateFilter.startDate)
    }

    var endDateString: String? {
        return formattedDateString(for: currentDateFilter.endDate)
    }

    // MARK: Lifecycle
    public init() {
        self.init(maximumEndDate: Date(), currentDateFilter: DateFilter(startDate: nil, endDate: nil))
    }
    
    public init(maximumEndDate: Date, currentDateFilter: DateFilter) {
        self.maximumEndDate = maximumEndDate
        self.currentDateFilter = currentDateFilter
        self.maximumStartDate = AddTripDateFilterViewModel.calculateMaximumStartDate(dateFilterEndDate: currentDateFilter.endDate,
                                                                              maximumEndDate: maximumEndDate)
        
        if let startDate = currentDateFilter.startDate {
            if startDate > maximumStartDate {
                self.currentDateFilter = DateFilter(startDate: maximumStartDate, endDate: currentDateFilter.endDate)
            }
        }
        if let endDate = currentDateFilter.endDate {
            if endDate > maximumEndDate {
                self.currentDateFilter = DateFilter(startDate: currentDateFilter.startDate, endDate: maximumEndDate)
            }
        }
    }

    // MARK: Updating
    public mutating func updateStartDate(_ startDate: Date?) {
        guard let startDate = startDate else {
            currentDateFilter = DateFilter(startDate: nil, endDate: currentDateFilter.endDate)
            return
        }
        
        guard startDate <= maximumStartDate else { return }
        var isEndDateValid = true
        if let endDate = currentDateFilter.endDate {
            isEndDateValid = startDate < endDate
        }
        
        currentDateFilter = DateFilter(startDate: startDate, endDate: isEndDateValid ? currentDateFilter.endDate : nil)
    }
    
    public mutating func updateEndDate(_ endDate: Date?) {
        guard let endDate = endDate else {
            currentDateFilter = DateFilter(startDate: currentDateFilter.startDate, endDate: nil)
            return
        }
        
        guard endDate <= maximumEndDate else { return }
        var isStartDateValid = true
        if let startDate = currentDateFilter.startDate {
            isStartDateValid = startDate < endDate
        }
        currentDateFilter = DateFilter(startDate: isStartDateValid ? currentDateFilter.startDate : nil, endDate: endDate)
    }
    
    // MARK: - Private
    static private func calculateMaximumStartDate(dateFilterEndDate: Date?, maximumEndDate: Date) -> Date {
        var components = DateComponents()
        components.day = -1
        
        if let endDate = dateFilterEndDate {
            return Calendar.current.date(byAdding: components, to: endDate)!
        } else {
            return Calendar.current.date(byAdding: components, to: maximumEndDate)!
        }
    }
    
    private func formattedDateString(for date:Date?) -> String? {
        if let date = date {
            return DateFormatter.tripDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    private func calculatedMaximumStartDate() -> Date {
        return AddTripDateFilterViewModel.calculateMaximumStartDate(dateFilterEndDate: currentDateFilter.endDate,
                                                             maximumEndDate: maximumEndDate)
    }
    
}
