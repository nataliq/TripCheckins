//
//  CheckinTableViewCell.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

class CheckinTableViewCell: UITableViewCell {

    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configure(withVenueName venueName: String, location locationName: String, date dateString: String) {
        venueNameLabel.text = venueName
        locationNameLabel.text = locationName
        dateLabel.text = dateString
    }
}

extension CheckinTableViewCell {
    func configure(withViewModel viewModel:CheckinListItemViewModel) {
        configure(withVenueName: viewModel.venueName,
                  location: viewModel.locationName,
                  date: viewModel.dateString)
    }
}
