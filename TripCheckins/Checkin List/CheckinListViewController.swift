//
//  CheckinListViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

class CheckinListViewController: UITableViewController {
    let checkinsDataSource: CheckinsDataSource
    let viewModel: CheckinListViewModel
    
    init(checkinsDataSource: CheckinsDataSource, viewModel: CheckinListViewModel) {
        self.checkinsDataSource = checkinsDataSource
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        let nib = UINib(nibName: viewModel.cellsNibName, bundle: Bundle(for: self.classForCoder))
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = viewModel.cellsHeight
        tableView.allowsSelection = false
        
        checkinsDataSource.reloadItems { self.tableView.reloadData() }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkinsDataSource.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CheckinTableViewCell
        let item = checkinsDataSource.itemForIndex(indexPath.row)
        cell.configureWithVenueName(item.venueName, location: item.locationName, date: item.dateString)
        return cell
    }
}
