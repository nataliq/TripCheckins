//
//  AllCheckinsListController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct DateFilter {
    let startDate: Date?
    let endDate: Date?
}

protocol DateFiltering {
    func filter(withDateFilter dateFilter:DateFilter)
}

class AllCheckinsListController: CheckinListController {
    var onViewModelUpdate: (() -> ())?
    
    var currentDateFilter: DateFilter? {
        didSet {
            reloadListItems()
        }
    }
    
    private(set) var currentListViewModel: CheckinListViewModel? {
        didSet {
            guard let updateClosure = onViewModelUpdate else { return }
            updateClosure()
        }
    }
    
    private let checkinsService: CheckinService
    private var currentListItems: [CheckinItem]?
    
    init(checkinsService: CheckinService) {
        self.checkinsService = checkinsService
    }
    
    func reloadListItems() {
        guard !isLoading() else { return }
        
        currentListViewModel = AllCheckinsListController.viewModelWithState(.loadingItems(currentDateFilter))
        checkinsService.loadCheckins(after: currentDateFilter?.startDate, before: currentDateFilter?.endDate, completionHandler: { [weak self] (listItems) in
            guard self?.currentListViewModel != nil else { return }
            self?.currentListItems = listItems
            self?.currentListViewModel?.populateWithListItems(from: listItems)
        })
    }
    
    private static func viewModelWithState(_ state:ListViewModelState) -> CheckinListViewModel {
        return CheckinListViewModel(title: "All checkins",
                                    listItemViewsType: .compact,
                                    state: state)
    }
}

extension AllCheckinsListController: DateFiltering {
    func filter(withDateFilter dateFilter: DateFilter) {
        guard let currentListItems = currentListItems else { return }
        let filteredItems = currentListItems.filter(withDateFilter: dateFilter)
        let listItemViewModels = filteredItems.map( {CheckinListItemViewModel(checkinItem: $0)} )
        currentListViewModel = AllCheckinsListController.viewModelWithState(.loadedListItemViewModels(listItemViewModels))
        currentDateFilter = dateFilter
    }
    
}

extension Array where Element == CheckinItem {
    func filter(withDateFilter dateFilter: DateFilter) -> [CheckinItem] {
        return filter { item -> Bool in
            if let startDate = dateFilter.startDate, let endDate = dateFilter.endDate {
                return (startDate...endDate).contains(item.date)
            }
            if let startDate = dateFilter.startDate {
                return item.date >= startDate
            }
            if let endDate = dateFilter.endDate {
                return item.date <= endDate
            }
            return true
        }
    }
}
