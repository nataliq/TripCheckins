//
//  LocalTripsController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/27/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol TripsController: ViewModelUpdateReporting {
    var tripService: TripService { get }
    var tripViewModels: [TripViewModel]? { get }
    
    func tripId(forViewModelIndex viewModelIndex:Int) -> String
}

public protocol LocalItemsStorage {
    func object(forKey defaultName: String) -> Any?
    mutating func set(_ value: Any?, forKey defaultName: String)
}

class LocalTripsController: TripsController, Observer {
    var onViewModelUpdate: (() -> ())?
    
    private(set) var tripService: TripService
    private var trips: [Trip]?
    var tripViewModels: [TripViewModel]? {
        didSet {
            onViewModelUpdate?()
        }
    }
    
    init(tripService: TripService) {
        self.tripService = tripService
        self.tripService.addObserver(self)
        
        reloadTrips()
    }
    
    func tripId(forViewModelIndex viewModelIndex:Int) -> String {
        assert(viewModelIndex < trips!.count)
        let trip = trips![viewModelIndex]
        return trip.uuid
    }
    
    private func reloadTrips() {
        tripService.loadAllTrips({ [weak self] (trips) in
            self?.trips = trips
            self?.tripViewModels = trips.map({ (trip) -> TripViewModel in
                return TripViewModel(trip: trip)
            })
        })
    }
    
    // MARK: - Observer
    func didUpdateObservableObject(_ observable: Observable) {
        reloadTrips()
    }
}
