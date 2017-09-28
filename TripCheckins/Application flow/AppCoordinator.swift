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
    var foursquareAuthorizer: FoursquareAuthorizer?
    
    init(navigationController: UINavigationController,
         authorizationTokenKeeper: AuthorizationTokenKeeper? = nil) {
        self.navigationController = navigationController
        self.authorizationTokenKeeper = authorizationTokenKeeper
        
        if let token = authorizationTokenKeeper?.authorizationToken() {
            showCheckinsList(authorizationToken: token)
        } else {
            showAuthorizationViewController()
        }
    }

    func openURL(_ url:URL) -> Bool {
        guard let foursquareAuthorizer = foursquareAuthorizer else { return false }
        return foursquareAuthorizer.requestAccessCode(forURL: url)
    }
    
    // MARK: - Private
    private func showAuthorizationViewController() {
        do {
            let foursquareAuthorizer = try FoursquareAuthorizer()
            let viewController = FoursquareAuthorizationViewController(foursquareAuthorizer: foursquareAuthorizer)
            viewController.delegate = self
            pushViewController(viewController)
            self.foursquareAuthorizer = foursquareAuthorizer
        } catch let error {
            print(error)
        }
    }
    
    private func showCheckinsList(authorizationToken token:String) {
        let checkinsService = FoursquareCheckinService(authorizationToken: token)
        let controller = AllCheckinsListController(checkinsService: checkinsService)
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
        authorizationTokenKeeper?.persistAuthorizationToken(token)
        showCheckinsList(authorizationToken: token)
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
