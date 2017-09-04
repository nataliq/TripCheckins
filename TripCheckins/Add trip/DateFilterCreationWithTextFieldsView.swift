//
//  DateFilterCreationWithTextFieldsView.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/16/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol DateFilterCreationView {
    var currentDateFilter: DateFilter { get }
}

class DateFilterCreationWithTextFieldsView: UIView, DateFilterCreationView, UITextFieldDelegate {
    
    var currentDateFilter: DateFilter {
        return viewModel.dateFilter
    }
    
    convenience init() {
        self.init(viewModel: DateFilterViewModel())
    }
    
    init(viewModel: DateFilterViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.delegate = self
        addSubview(startDateTextField)
        
        endDateTextField.inputView = endDatePicker
        endDateTextField.delegate = self
        addSubview(endDateTextField)
        
        addLayoutConstraints()
        syncViewWithViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: DateFilterViewModel {
        didSet {
            syncViewWithViewModel()
        }
    }
    
    private func syncViewWithViewModel() {
        self.startDateTextField.text = viewModel.startDateString
        self.endDateTextField.text = viewModel.endDateString
        
        self.startDatePicker.maximumDate = viewModel.maximumStartDate
        self.endDatePicker.maximumDate = viewModel.maximumEndDate
        
        if let startDate = viewModel.dateFilter.startDate {
            self.startDatePicker.date = startDate
        }
        
        if let endDate = viewModel.dateFilter.endDate {
            self.endDatePicker.date = endDate
        }
    }
    
    private let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let startDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.placeholder = "from:"
        textField.clearButtonMode = .always
        return textField
    }()
    
    private let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let endDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.placeholder = "to:"
        textField.clearButtonMode = .always
        return textField
    }()
    
    @objc private func datePickerValueChanged(_ datePicker:UIDatePicker) {
        if datePicker === startDatePicker {
            viewModel.updateStartDate(datePicker.date)
        } else if datePicker === endDatePicker {
            viewModel.updateEndDate(datePicker.date)
        }
    }
    
    private func addLayoutConstraints() {
        [startDateTextField, endDateTextField].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        
        addConstraints([
            NSLayoutConstraint(item: startDateTextField, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 11),
            NSLayoutConstraint(item: startDateTextField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: startDateTextField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: endDateTextField, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -11),
            NSLayoutConstraint(item: endDateTextField, attribute: .top, relatedBy: .equal, toItem: startDateTextField, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: endDateTextField, attribute: .bottom, relatedBy: .equal, toItem: startDateTextField, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: startDateTextField, attribute: .right, relatedBy: .equal, toItem: endDateTextField, attribute: .left, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: startDateTextField, attribute: .width, relatedBy: .equal, toItem: endDateTextField, attribute: .width, multiplier: 1, constant: 0)
            ]
        )
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField === startDateTextField {
            viewModel.updateStartDate(nil)
        } else if textField === endDateTextField {
            viewModel.updateEndDate(nil)
        }
        return true
    }
}
