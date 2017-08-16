//
//  AddTripViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/16/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol AddTripViewControllerDelegate: class {
    func addTripControllerDidTriggerAddAction(_ controller: AddTripViewController)
    func addTripControllerDidCancel(_ controller: AddTripViewController)
}

class AddTripViewController: UIViewController {

    weak var delegate: AddTripViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Add trip"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonTapped(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped(_:)))
    }

    @objc func doneButtonTapped(_ sender: Any) {
        delegate?.addTripControllerDidTriggerAddAction(self)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        delegate?.addTripControllerDidCancel(self)
    }

}
