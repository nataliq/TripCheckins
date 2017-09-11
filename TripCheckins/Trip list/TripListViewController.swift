//
//  TripListViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/27/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol TripListViewControllerDelegate: class {
    func tripListViewController(_ controller: TripListViewController,
                                didSelectTripWithId tripId: String)
}

class TripListViewController: UITableViewController {

    private let cellIdentifier = "Cell"
    private(set) var controller: TripsController
    
    weak var delegate: TripListViewControllerDelegate?
    
    init(controller: TripsController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trips"
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.tripViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let viewModel = controller.tripViewModels![indexPath.row]
        cell!.textLabel?.text = viewModel.title
        cell!.detailTextLabel?.text = viewModel.durationString
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripId = controller.tripId(forViewModelIndex: indexPath.row)
        delegate?.tripListViewController(self, didSelectTripWithId: tripId)
    }

}
