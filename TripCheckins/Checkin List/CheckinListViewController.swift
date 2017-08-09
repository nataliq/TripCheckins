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
    
    init(checkinsDataSource: CheckinsDataSource) {
        self.checkinsDataSource = checkinsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checkins list"
        let nib = UINib(nibName: "CompactCheckinTableViewCell", bundle: Bundle(for: self.classForCoder))
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 80
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
