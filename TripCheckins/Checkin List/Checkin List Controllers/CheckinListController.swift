//
//  CheckinListController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol CheckinListController {
    var currentListViewModel: CheckinListViewModel? { get }
    var onViewModelUpdate: (() -> ())? { set get }
    
    func reloadListItems()
}

extension CheckinListController {
    func isLoading() -> Bool {
        guard let listViewModel = self.currentListViewModel else { return false }
        if case .loadingItems = listViewModel.state {
            return true
        } else {
            return false
        }
    }
}
