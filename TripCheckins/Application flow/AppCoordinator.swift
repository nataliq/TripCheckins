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
    let authorizationTokenKeeper: AuthorizationTokenKeeper
    let localItemsStorage: LocalItemsStorage
    
    private lazy var tripService = LocalTripService(localItemsStorage: localItemsStorage,
                                                    additionalTripLoadingService: PredefinedTripService())
    
    var foursquareAuthorizer: FoursquareAuthorizer?
    
    init(navigationController: UINavigationController,
         authorizationTokenKeeper: AuthorizationTokenKeeper,
         localItemsStorage: LocalItemsStorage) {
        self.navigationController = navigationController
        self.authorizationTokenKeeper = authorizationTokenKeeper
        self.localItemsStorage = localItemsStorage
        
        guard authorizationTokenKeeper.authorizationToken() != nil else {
            showAuthorizationViewController()
            return
        }
        
        showTripList()
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
    
    private func showCheckinsList(authorizationToken token: String) {
        let checkinsService = FoursquareCheckinService(authorizationToken: token)
        let controller = AllCheckinsListController(checkinsService: checkinsService)
        let viewController = CheckinListViewController(controller: controller)
        viewController.delegate = self
        pushViewController(viewController)
    }
    
    private func showTripList() {
        let controller = LocalTripsController(tripService: tripService)
        let viewController = TripListViewController(controller: controller)
        viewController.delegate = self
        pushViewController(viewController)
    }
    
    private func showTrip(withId tripId: String) {
        guard let token = authorizationTokenKeeper.authorizationToken() else {
            showAuthorizationViewController()
            return
        }
        
        let checkinsService = FoursquareCheckinService(authorizationToken: token)
        let controller = TripCheckinsListController(checkinsService: checkinsService,
                                                    tripService: tripService,
                                                    tripId: tripId)
        let viewController = CheckinListViewController(controller: controller)
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
        authorizationTokenKeeper.persistAuthorizationToken(token)
        showTripList()
    }
}

extension AppCoordinator: AddTripViewControllerDelegate {
    func addTripController(_ controller: AddTripViewController,
                           didAddTripWithId tripId: String) {
        controller.dismiss(animated: true, completion: { [weak self] in
            self?.showTrip(withId: tripId)
        })
    }
    
    func addTripControllerDidCancel(_ controller: AddTripViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AppCoordinator: CheckinListViewControllerDelegate {
    
}

extension AppCoordinator: TripListViewControllerDelegate {
    func tripListViewControllerDidTriggerAddAction(_ controller: TripListViewController) {
        let viewModel = AddTripDateFilterViewModel()
        let dateFilterCreationView = DateFilterCreationView(viewModel: viewModel)
        let viewController = AddTripViewController(dateFilterCreationView: dateFilterCreationView,
                                                   tripCreationService: controller.tripsController.tripService)
        let addTripNavigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        
        navigationController.viewControllers.last?.present(addTripNavigationController,
                                                           animated: true, completion: nil)
    }
    
    func tripListViewController(_ controller: TripListViewController,
                                didSelectTripWithId tripId: String) {
        showTrip(withId: tripId)
    }
    
    
}
