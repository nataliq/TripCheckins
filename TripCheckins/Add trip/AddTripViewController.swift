//
//  AddTripViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/16/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol AddTripViewControllerDelegate: class {
    func addTripControllerDidTriggerAddAction(_ controller: AddTripViewController,
                                              dateFilter filter:DateFilter)
    func addTripControllerDidCancel(_ controller: AddTripViewController)
}

class AddTripViewController: UIViewController {

    weak var delegate: AddTripViewControllerDelegate?
    let dateFilterCreationView: UIView & DateFilterProvider
    
    init(dateFilterCreationView: UIView & DateFilterProvider) {
        self.dateFilterCreationView = dateFilterCreationView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appMainBackgroundColor()
        title = "Add trip"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped(_:)))
        view.addSubview(dateFilterCreationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dateFilterCreationView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 50)
    }

    // MARK: Actions
    @objc func doneButtonTapped(_ sender: Any) {
        let dateFilter = dateFilterCreationView.currentDateFilter
        delegate?.addTripControllerDidTriggerAddAction(self, dateFilter: dateFilter)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        delegate?.addTripControllerDidCancel(self)
    }

}
