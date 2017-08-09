//
//  CheckinTableViewCell.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/9/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

class CheckinTableViewCell: UITableViewCell {

    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureWithVenueName(_ venueName: String, location locationName: String, date dateString: String) {
        venueNameLabel.text = venueName
        locationNameLabel.text = locationName
        dateLabel.text = dateString
    }

}
