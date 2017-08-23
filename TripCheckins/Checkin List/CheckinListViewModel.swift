//
//  CheckinListViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

enum CheckinListItemViewsType {
    case compact
    case normal
}

enum ListViewModelState {
    case loadingItems(DateFilter?)
    case error(String)
    case loadedListItemViewModels([CheckinListItemViewModel])
}

struct CheckinListViewModel {
    let title: String
    let listItemViewsType: CheckinListItemViewsType
    var state: ListViewModelState
    
    func listItemsCount() -> Int {
        switch state {
        case .loadedListItemViewModels(let itemsViewModels):
            return itemsViewModels.count
        default:
            return 0
        }
    }
    
    func listItemViewModel(at index:Int) -> CheckinListItemViewModel? {
        switch state {
        case .loadedListItemViewModels(let itemsViewModels):
            return itemsViewModels[index]
        default:
            return nil
        }
    }
    
    mutating func populateWithListItems(from checkinItems:[CheckinItem]) {
        state = .loadedListItemViewModels(checkinItems.map( {CheckinListItemViewModel(checkinItem: $0)} ))
    }
}
