//
//  AppCoordicator.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

class AppCoordinator: FoursquareAuthorizationViewControllerDelegate {
    
    let navigationController: UINavigationController
    let authorizationTokenKeeper: AuthorizationTokenKeeper?
    var foursquareAuthorizer: FoursquareAuthorizer?
    
    init(navigationController: UINavigationController, authorizationTokenKeeper: AuthorizationTokenKeeper?) {
        self.navigationController = navigationController
        self.authorizationTokenKeeper = authorizationTokenKeeper
    }
    
    func start() {
        if let token = authorizationTokenKeeper?.authorizationToken() {
            showCheckinsList(authorizationToken: token)
        } else {
            pushAuthorizationViewController()
        }
    }
    
    func processURL(_ url:URL) -> Bool {
        // TODO: redirect to child coordinators
        guard url.absoluteString.contains("foursquare") else { return false }
        guard let foursquareAuthorizer = foursquareAuthorizer else { return false }
        return foursquareAuthorizer.requestAccessCode(forURL: url)
    }
    
    // MARK: - FoursquareAuthorizationViewControllerDelegate
    func didFinishAuthorizationFlow(_ token: String) {
        authorizationTokenKeeper?.persistAuthorizationToken(token)
        showCheckinsList(authorizationToken: token)
    }
    
    // MARK: - Private
    private func pushAuthorizationViewController() {
        // TODO: move to a child coordinator
        let foursquareAuthorizer = FoursquareAuthorizer.init(clientId: "SO0SBDKGOYSZCH4JMQOEHJHMNTETYOWCURGWAZ22BPHKQDWE",
                                                             clientSecret: "KBYTRDYUXSUULW4P4YDELCDQVF3FZ1ZKNHLJOF0MLZ2CGUMQ",
                                                             callbackURIString: "tripcheckins://foursquare")
        let viewController = FoursquareAuthorizationViewController(foursquareAuthorizer: foursquareAuthorizer)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
        self.foursquareAuthorizer = foursquareAuthorizer
    }
    
    private func showCheckinsList(authorizationToken token:String) {
        // TODO: move to a child coordinator
        let fetcher = CheckinFetcher(authorizationToken: token)
        let dataSource = CheckinsDataSource(fetcher: fetcher, parser: CheckinItemsParser())
        let controller = CheckinListViewController(checkinsDataSource: dataSource)
        
        let animated = navigationController.viewControllers.count > 0
        navigationController.pushViewController(controller, animated: animated)
    }
}
