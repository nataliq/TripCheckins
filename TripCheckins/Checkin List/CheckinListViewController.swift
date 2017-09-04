//
//  CheckinListViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol CheckinListViewControllerDelegate: class {
    func listViewControllerDidTriggerAddAction(_ controller: CheckinListViewController)
}

extension CheckinListViewController: DateFiltering {
    func filter(withDateFilter dateFilter: DateFilter) {
        if let controller = controller as? DateFiltering {
            controller.filter(withDateFilter: dateFilter)
        }
    }
}

class CheckinListViewController: UITableViewController {
    
    private(set) var controller: CheckinListController
    private var listViewModels: [CheckinListItemViewModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    weak var delegate: CheckinListViewControllerDelegate?
    
    init(controller: CheckinListController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
        
        self.controller.onViewModelUpdate = { [weak self] in
            guard let listViewModel = self?.controller.currentListViewModel else { return }
            self?.configureWithViewModel(listViewModel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        let refreshAction = #selector(refresh(_:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: refreshAction)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: refreshAction, for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        
        controller.reloadListItems()
    }
    
    private func revealRefreshControlIfContentIsNotScrolled() {
        guard let refreshControl = refreshControl else { return }
        guard tableView.contentOffset.y <= 0 else { return }
        
        let yOffset = tableView.contentOffset.y - refreshControl.frame.size.height
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: yOffset), animated: true)
    }
    
    // MARK: - Actions
    @objc func refresh(_ sender: Any) {
        controller.reloadListItems()
    }
    
    @objc func addButtonTapped(_ sender: Any) {
        delegate?.listViewControllerDidTriggerAddAction(self)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CheckinTableViewCell
        cell.configure(withViewModel: listViewModels![indexPath.row])
        return cell
    }
    
    // MARK: - View-model configuration
    private func configureWithViewModel(_ viewModel: CheckinListViewModel) {
        title = viewModel.title
        
        let nib = UINib(nibName: "CompactCheckinTableViewCell", bundle: Bundle(for: self.classForCoder))
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        switch viewModel.listItemViewsType {
        case .compact:
            tableView.rowHeight = 80
        case .normal:
            tableView.rowHeight = 120
        }
        
        updateViewsForViewModelState(viewModel.state)
    }
    
    private func updateViewsForViewModelState(_ state: ListViewModelState) {
        guard isViewLoaded else { return }
        
        switch state {
        case .loadingItems:
            refreshControl?.beginRefreshing()
            revealRefreshControlIfContentIsNotScrolled()
        case .error(_):
            refreshControl?.endRefreshing()
        case .loadedListItemViewModels(let viewModels):
            listViewModels = viewModels
            refreshControl?.endRefreshing()
        }
    }
}

