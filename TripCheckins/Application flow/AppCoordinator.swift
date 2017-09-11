//
//  AppCoordicator.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    let navigationController: UINavigationController
    let authorizationTokenKeeper: AuthorizationTokenKeeper?
    let localItemsStorage: LocalItemsStorage?
    
    var foursquareAuthorizer: FoursquareAuthorizer?
    
    init(navigationController: UINavigationController,
         authorizationTokenKeeper: AuthorizationTokenKeeper? = nil,
         localItemsStorage: LocalItemsStorage? = nil) {
        self.navigationController = navigationController
        self.authorizationTokenKeeper = authorizationTokenKeeper
        self.localItemsStorage = localItemsStorage
        
        guard let token = authorizationTokenKeeper?.authorizationToken() else {
            showAuthorizationViewController()
            return
        }
        
        showTripListOrAllCheckins(authorizationToken: token)
    }

    func openURL(_ url:URL) -> Bool {
        guard let foursquareAuthorizer = foursquareAuthorizer else { return false }
        return foursquareAuthorizer.requestAccessCode(forURL: url)
    }
    
    // MARK: - Private
    private func showAuthorizationViewController() {
        let foursquareAuthorizer = FoursquareAuthorizer()
        let viewController = FoursquareAuthorizationViewController(foursquareAuthorizer: foursquareAuthorizer)
        viewController.delegate = self
        pushViewController(viewController)
        self.foursquareAuthorizer = foursquareAuthorizer
    }
    
    private func showTripListOrAllCheckins(authorizationToken token: String) {
        if let localItemsStorage = localItemsStorage {
            let tripService = LocalTripService(localItemsStorage: localItemsStorage, 
                                               additionalTripSource: PredefinedTripService())

            showTripList(withTripService: tripService)
        } else {
            showCheckinsList(authorizationToken: token)
        }
    }
    
    private func showCheckinsList(authorizationToken token: String) {
        let checkinsService = FoursquareCheckinService(authorizationToken: token)
        let controller = AllCheckinsListController(checkinsService: checkinsService)
        let viewController = CheckinListViewController(controller: controller)
        viewController.delegate = self
        pushViewController(viewController)
    }
    
    private func showTripList(withTripService tripService: TripService) {
        let controller = LocalTripsController(tripService: tripService)
        let viewController = TripListViewController(controller: controller)
        viewController.delegate = self
        pushViewController(viewController)
    }
    
    private func pushViewController(_ viewController:UIViewController) {
        let animated = navigationController.viewControllers.count > 0
        navigationController.pushViewController(viewController, animated: animated)
    }
}

extension AppCoordinator: FoursquareAuthorizationViewControllerDelegate {
    func didFinishAuthorizationFlow(_ token: String) {
        authorizationTokenKeeper?.persistAuthorizationToken(token)
        showTripListOrAllCheckins(authorizationToken: token)
    }
}

extension AppCoordinator: AddTripViewControllerDelegate {
    func addTripControllerDidTriggerAddAction(_ controller: AddTripViewController,
                                              dateFilter filter: DateFilter) {
        controller.dismiss(animated: true, completion: { [weak self] in
            // TODO: implement saving
            if let dateFilteringViewController = self?.navigationController.topViewController as? DateFiltering {
                dateFilteringViewController.filter(withDateFilter: filter)
            }
        })
    }
    
    func addTripControllerDidCancel(_ controller: AddTripViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AppCoordinator: CheckinListViewControllerDelegate {
    func listViewControllerDidTriggerAddAction(_ controller: CheckinListViewController) {
        let viewModel = AddTripDateFilterViewModel()
        let dateFilterCreationView = DateFilterCreationView(viewModel: viewModel)
        let viewController = AddTripViewController(dateFilterCreationView: dateFilterCreationView)
        let addTripNavigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        
        navigationController.viewControllers.last?.present(addTripNavigationController,
                                                           animated: true, completion: nil)
        
    }
}

extension AppCoordinator: TripListViewControllerDelegate {
    func tripListViewController(_ controller: TripListViewController,
                                didSelectTripWithId tripId: String) {
        guard let token = authorizationTokenKeeper?.authorizationToken() else {
            showAuthorizationViewController()
            return
        }
        
        let checkinsService = FoursquareCheckinService(authorizationToken: token)
        let controller = TripCheckinsListController(checkinsService: checkinsService,
                                                    tripService: controller.controller.tripService,
                                                    tripId: tripId)
        let viewController = CheckinListViewController(controller: controller)
        viewController.delegate = self
        pushViewController(viewController)
    }
    
    
}
