//
//  CheckinListViewModel.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/10/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

struct CheckinListViewModel {
    let title: String
    let listItemViewsType: CheckinListItemViewsType
    let state: ListViewModelState
}

enum CheckinListItemViewsType {
    case compact
    case normal
}

enum ListViewModelState {
    case loadingItems
    case error(String)
    case loadedListItemViewModels([CheckinListItemViewModel])
}

extension CheckinListViewModel {
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
}
