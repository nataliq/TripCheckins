//
//  CheckinService.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/11/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol CheckinService {
    func loadCheckins(after fromDate: Date?, before toDate: Date?, completionHandler: @escaping ([CheckinItem]) -> Void)
}
