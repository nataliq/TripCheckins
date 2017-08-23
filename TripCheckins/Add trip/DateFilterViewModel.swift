//
//  DateFilterViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/17/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct DateFilterViewModel {
    
    init(dateFilter: DateFilter) {
        self.dateFilter = dateFilter
        self.maximumStartDate = DateFilterViewModel.calculateMaximumStartDate(dateFilterEndDate: dateFilter.endDate,
                                                                              maximumEndDate: maximumEndDate)
        
        if let startDate = dateFilter.startDate {
            if startDate > maximumStartDate {
                self.dateFilter = DateFilter(startDate: maximumStartDate, endDate: dateFilter.endDate)
            }
        }
        if let endDate = dateFilter.endDate {
            if endDate > maximumEndDate {
                self.dateFilter = DateFilter(startDate: dateFilter.startDate, endDate: maximumEndDate)
            }
        }
    }
    
    private(set) var dateFilter: DateFilter {
        didSet {
            maximumStartDate = DateFilterViewModel.calculateMaximumStartDate(dateFilterEndDate: dateFilter.endDate,
                                                                             maximumEndDate: maximumEndDate)
        }
    }
    
    let maximumEndDate = Date()
    private(set) var maximumStartDate: Date
    
    static private func calculateMaximumStartDate(dateFilterEndDate: Date?, maximumEndDate: Date) -> Date {
        var components = DateComponents()
        components.day = -1
        
        if let endDate = dateFilterEndDate {
            return Calendar.current.date(byAdding: components, to: endDate)!
        } else {
            return Calendar.current.date(byAdding: components, to: maximumEndDate)!
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var startDateString: String? {
        if let startDate = dateFilter.startDate {
            return dateFormatter.string(from: startDate)
        } else {
            return nil
        }
    }
    
    var endDateString: String? {
        if let endDate = dateFilter.endDate {
            return dateFormatter.string(from: endDate)
        } else {
            return nil
        }
    }
    
    
    mutating func updateStartDate(_ startDate: Date?) {
        guard let startDate = startDate else {
            dateFilter = DateFilter(startDate: nil, endDate: dateFilter.endDate)
            return
        }
        
        guard startDate <= maximumStartDate else { return }
        var isEndDateValid = true
        if let endDate = dateFilter.endDate {
            isEndDateValid = startDate < endDate
        }
        
        dateFilter = DateFilter(startDate: startDate, endDate: isEndDateValid ? dateFilter.endDate : nil)
    }
    
    mutating func updateEndDate(_ endDate: Date?) {
        guard let endDate = endDate else {
            dateFilter = DateFilter(startDate: dateFilter.startDate, endDate: nil)
            return
        }
        
        guard endDate <= maximumEndDate else { return }
        var isStartDateValid = true
        if let startDate = dateFilter.startDate {
            isStartDateValid = startDate < endDate
        }
        dateFilter = DateFilter(startDate: isStartDateValid ? dateFilter.startDate : nil, endDate: endDate)
    }
}
