//
//  AllCheckinsListController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class AllCheckinsListController: CheckinListController {
    var onViewModelUpdate: (() -> ())?
    private(set) var currentListViewModel: CheckinListViewModel? {
        didSet {
            guard let updateClosure = onViewModelUpdate else { return }
            updateClosure()
        }
    }
    
    private let checkinsService: CheckinService
    
    init(checkinsService: CheckinService) {
        self.checkinsService = checkinsService
    }
    
    func reloadListItems() {
        guard !isLoading() else { return }
        
        currentListViewModel = CheckinListViewModel(title: "All checkins",
                                                    cellsNibName: "CompactCheckinTableViewCell",
                                                    cellsHeight: 80,
                                                    state: .loadingItems)
        checkinsService.loadCheckins(after: nil, before: nil, completionHandler: { (listItems) in
            guard self.currentListViewModel != nil else { return }
            self.currentListViewModel?.populateWithListItems(from: listItems)
        })
    }
}
