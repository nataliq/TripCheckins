//
//  AddTripViewControllerTests.swift
//  TripCheckinsTests
//
//  Created by Nataliya  on 9/1/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import XCTest
@testable import TripCheckins

class AddTripViewControllerTests: XCTestCase {
    
    var viewController: AddTripViewController!
    var viewControllerNavigationController: UINavigationController!
    let viewControllerDelegate = TestAddTripViewControllerDelegate()
    let dateFilter = DateFilter(startDate: Date().addingTimeInterval(-1), endDate: Date())
    
    override func setUp() {
        super.setUp()
        
        let dateFilterCreationView = TestDateFilterCreationView(dateFilter: dateFilter)
        viewController = AddTripViewController(dateFilterCreationView: dateFilterCreationView)
        viewController.delegate = viewControllerDelegate
        
        viewControllerNavigationController = UINavigationController(rootViewController: viewController)
        viewController.viewDidLoad()
    }
    
    class TestDateFilterCreationView: UIView, DateFilterCreationView {
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
        var addActionDateFilter: DateFilter?
        var cancelActionTriggered = false
        
        func addTripControllerDidTriggerAddAction(_ controller: AddTripViewController, dateFilter filter: DateFilter) {
            addActionDateFilter = filter
        }
        
        func addTripControllerDidCancel(_ controller: AddTripViewController) {
            cancelActionTriggered = true
        }
    }
    
    func testAddButtonAction() {
        XCTAssertNotNil(viewController.doneButton)
        XCTAssertNotNil(viewController.doneButton!.action)
        
        UIApplication.shared.sendAction(viewController.doneButton!.action!,
                                        to: viewController.doneButton!.target,
                                        from: nil,
                                        for: nil)
        
        XCTAssertNotNil(viewControllerDelegate.addActionDateFilter)
        XCTAssertEqual(viewControllerDelegate.addActionDateFilter!.startDate, dateFilter.startDate)
        XCTAssertEqual(viewControllerDelegate.addActionDateFilter!.endDate, dateFilter.endDate)
        XCTAssertFalse(viewControllerDelegate.cancelActionTriggered)
    }
    
    func testCancelButtonAction() {
        XCTAssertNotNil(viewController.cancelButton)
        XCTAssertNotNil(viewController.cancelButton!.action)
        
        UIApplication.shared.sendAction(viewController.cancelButton!.action!,
                                        to: viewController.cancelButton!.target,
                                        from: nil,
                                        for: nil)
        
        XCTAssertNil(viewControllerDelegate.addActionDateFilter)
        XCTAssertTrue(viewControllerDelegate.cancelActionTriggered)
    }
    
}
