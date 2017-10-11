//
//  TripListViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/27/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol TripListViewControllerDelegate: class {
    func tripListViewControllerDidTriggerAddAction(_ controller: TripListViewController)
    func tripListViewController(_ controller: TripListViewController,
                                didSelectTripWithId tripId: String)
}

class TripListViewController: UITableViewController {

    private let cellIdentifier = "Cell"
    private(set) var tripsController: TripsController
    
    weak var delegate: TripListViewControllerDelegate?
    
    init(controller: TripsController) {
        self.tripsController = controller
        super.init(nibName: nil, bundle: nil)
        
        self.tripsController.onViewModelUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trips"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    @objc func addButtonTapped(_ sender: Any) {
        delegate?.tripListViewControllerDidTriggerAddAction(self)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsController.tripViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)

        let viewModel = tripsController.tripViewModels![indexPath.row]
        cell.textLabel?.text = viewModel.title
        cell.detailTextLabel?.text = viewModel.durationString
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripId = tripsController.tripId(forViewModelIndex: indexPath.row)
        delegate?.tripListViewController(self, didSelectTripWithId: tripId)
    }

}
