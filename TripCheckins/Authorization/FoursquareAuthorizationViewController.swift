//
//  ViewController.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import UIKit

protocol FoursquareAuthorizationViewControllerDelegate: class {
    func didFinishAuthorizationFlow(_ token:String)
}

class FoursquareAuthorizationViewController: UIViewController, FoursquareAuthorizerDelegate {

    let foursquareAuthorizer: FoursquareAuthorizer
    
    weak var delegate: FoursquareAuthorizationViewControllerDelegate?
    
    init(foursquareAuthorizer: FoursquareAuthorizer) {
        self.foursquareAuthorizer = foursquareAuthorizer
        super.init(nibName: nil, bundle: nil)
        
        self.foursquareAuthorizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        let result = self.foursquareAuthorizer.presentConnectUI(withPresenter: self)
        
        if !result.success {
            print(result.message!)
        }
    }

    // MARK: - FoursquareAuthorizerDelegate
    func didFinishFetchingAuthorizationToken(_ token: String?) {
        if let token = token {
            delegate?.didFinishAuthorizationFlow(token)
        } else {
            showErrorUI()
        }
    }
    
    func showErrorUI() {
        
    }
}

