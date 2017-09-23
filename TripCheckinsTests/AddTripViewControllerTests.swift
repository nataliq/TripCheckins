//
//  AddTripViewControllerTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 9/1/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

extension AddTripViewController {
    var doneButton: UIBarButtonItem? {
        return self.navigationItem.rightBarButtonItem
    }
    
    var cancelButton: UIBarButtonItem? {
        return self.navigationItem.leftBarButtonItem
    }
}

class AddTripViewControllerTests: XCTestCase {
    
    var viewController: AddTripViewController!
    var viewControllerNavigationController: UINavigationController!
    let viewControllerDelegate = TestAddTripViewControllerDelegate()
    let dateFilter = DateFilter(startDate: Date().addingTimeInterval(-1), endDate: Date())
    let tripCreationService = TestTripCreationService()
    
    override func setUp() {
        super.setUp()
        
        let dateFilterCreationView = TestDateFilterCreationView(dateFilter: dateFilter)
        viewController = AddTripViewController(dateFilterCreationView: dateFilterCreationView,
                                               tripCreationService: tripCreationService)
        viewController.delegate = viewControllerDelegate
        
        viewControllerNavigationController = UINavigationController(rootViewController: viewController)
        viewController.viewDidLoad()
    }
    
    class TestDateFilterCreationView: UIView, DateFilterProvider {
        let currentDateFilter: DateFilter
        
        init(dateFilter: DateFilter) {
            currentDateFilter = dateFilter
            super.init(frame: .zero)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class TestAddTripViewControllerDelegate: AddTripViewControllerDelegate {
        var tripId: String?
        var cancelActionTriggered = false
        
        func addTripController(_ controller: AddTripViewController, didAddTripWithId tripId: String) {
            self.tripId = tripId
        }
        
        func addTripControllerDidCancel(_ controller: AddTripViewController) {
            cancelActionTriggered = true
        }
    }
    
    class TestTripCreationService: TripCreationService {
        var addedTrip: Trip?
        func addTrip(_ trip: Trip) {
            addedTrip = trip
        }
        func addObserver(_ observer: AnyObject & Observer) { }
        func removeObserver(_ observer: AnyObject & Observer) { }
    }
    
    func testAddButtonAction() {
        XCTAssertNotNil(viewController.doneButton)
        XCTAssertNotNil(viewController.doneButton!.action)
        
        UIApplication.shared.sendAction(viewController.doneButton!.action!,
                                        to: viewController.doneButton!.target,
                                        from: nil,
                                        for: nil)
        
        XCTAssertNotNil(tripCreationService.addedTrip)
        XCTAssertNotNil(viewControllerDelegate.tripId)
        XCTAssertEqual(viewControllerDelegate.tripId, tripCreationService.addedTrip!.uuid)
        XCTAssertFalse(viewControllerDelegate.cancelActionTriggered)
    }
    
    func testCancelButtonAction() {
        XCTAssertNotNil(viewController.cancelButton)
        XCTAssertNotNil(viewController.cancelButton!.action)
        
        UIApplication.shared.sendAction(viewController.cancelButton!.action!,
                                        to: viewController.cancelButton!.target,
                                        from: nil,
                                        for: nil)
        
        XCTAssertNil(tripCreationService.addedTrip)
        XCTAssertNil(viewControllerDelegate.tripId)
        XCTAssertTrue(viewControllerDelegate.cancelActionTriggered)
    }
    
}
