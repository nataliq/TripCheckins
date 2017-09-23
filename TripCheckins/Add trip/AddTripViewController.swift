//
//  AddTripViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/16/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol AddTripViewControllerDelegate: class {
    func addTripController(_ controller: AddTripViewController,
                           didAddTripWithId tripId: String)
    func addTripControllerDidCancel(_ controller: AddTripViewController)
}

class AddTripViewController: UIViewController {

    weak var delegate: AddTripViewControllerDelegate?
    let dateFilterCreationView: UIView & DateFilterProvider
    let tripCreationService: TripCreationService
    
    // TODO: Create view model for the text field and use it to disable the Done button
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Title"
        return textField
    }()
    
    init(dateFilterCreationView: UIView & DateFilterProvider, tripCreationService: TripCreationService) {
        self.dateFilterCreationView = dateFilterCreationView
        self.tripCreationService = tripCreationService
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
        view.addSubview(titleTextField)
        view.addSubview(dateFilterCreationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleTextField.frame = CGRect(x: 11, y: 100, width: view.frame.width - 22, height: 50)
        dateFilterCreationView.frame = CGRect(x: 0, y: 170, width: view.frame.width, height: 50)
    }

    // MARK: Actions
    @objc func doneButtonTapped(_ sender: Any) {
        let dateFilter = dateFilterCreationView.currentDateFilter
        var title = "New trip"
        if let text = titleTextField.text, text.isEmpty == false {
            title = text
        }
        let trip = Trip(startDate: dateFilter.startDate, endDate: dateFilter.endDate, name: title)
        tripCreationService.addTrip(trip)
        delegate?.addTripController(self, didAddTripWithId: trip.uuid)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        delegate?.addTripControllerDidCancel(self)
    }

}
