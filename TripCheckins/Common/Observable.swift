//
//  Observable.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/12/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol Observable {
    func addObserver(_ observer: AnyObject & Observer)
    func removeObserver(_ observer: AnyObject & Observer)
}

protocol Observer: class {
    func didUpdateObservableObject(_ observable: Observable)
}
