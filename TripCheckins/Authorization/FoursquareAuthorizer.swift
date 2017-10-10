//
//  FoursquareAuthorizer.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol FoursquareAuthorizerDelegate: class {
    func didFinishFetchingAuthorizationToken(_ token:String?)
}

enum FoursquareConfigurationError: Error {
    case missingConfigurationFile
    case missingConfigurationValueForKey(String)
}

private let configurationPlistPath = "foursquare_api_configuration"
private let clientIdKey = "client_id"
private let clientSecretKey = "client_secret"
private let callbackURIStringKey = "callback_uri"

final class FoursquareAuthorizer {
    
    private let clientId: String
    private let clientSecret: String
    private let callbackURIString: String
    private var tokenHandler: ((String?) -> ())?
    
    convenience init() throws {
        guard let plistPath = Bundle.main.path(forResource: configurationPlistPath, ofType: "plist"),
            let configuration = NSDictionary(contentsOfFile: plistPath) as? [String: String] else {
                throw FoursquareConfigurationError.missingConfigurationFile
        }
        
        let getConfigurationValueForKey: (String) throws -> (String) = { key in
            guard let value = configuration[key] else {
                throw FoursquareConfigurationError.missingConfigurationValueForKey(key)
            }
            return value
        }
        
        self.init(clientId: try getConfigurationValueForKey(clientIdKey),
                  clientSecret: try getConfigurationValueForKey(clientSecretKey),
                  callbackURIString: try getConfigurationValueForKey(callbackURIStringKey))
    }
    
    init(clientId: String, clientSecret: String, callbackURIString: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackURIString = callbackURIString
    }
    
    func initiateAuthorizationFlow(withPresenter presenter: UIViewController,
                                   tokenHandler handler: @escaping (String?) -> ()) {
        tokenHandler = handler
        presentConfirmationAlert(withPresenter: presenter)
    }
    
    func requestAccessCode(forURL url:URL) -> Bool {
        guard url.absoluteString.contains("foursquare") else { return false }
        var errorCode: FSOAuthErrorCode = FSOAuthErrorCode.none
        
        let accessCode = FSOAuth.shared().accessCode(forFSOAuthURL: url, error: &errorCode)
        
        guard errorCode == FSOAuthErrorCode.none else { return false }
        guard let code = accessCode else { return false }
        
        requestAccessToken(forCode: code)
        
        return true
    }
    
    // MARK: - Private
    
    private func presentConfirmationAlert(withPresenter presenter:UIViewController) {
        let alertMessage = "Link the app to your Foursquare account so that it can retrieve your checkins information"
        let alertController = UIAlertController(title: "Use Foursquare?",
                                                message: alertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.presentConnectUI(withPresenter: presenter)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.tokenHandler?(nil)
        })
        
        presenter.present(alertController, animated: true, completion: nil)
    }
    private func presentConnectUI(withPresenter presenter: UIViewController) {
        let statuscode: FSOAuthStatusCode = FSOAuth.shared().authorizeUser(usingClientId: clientId,
                                                                           nativeURICallbackString: callbackURIString,
                                                                           universalURICallbackString: nil,
                                                                           allowShowingAppStore: true,
                                                                           presentFrom: presenter)
        let response = connectResponse(forStatusCode: statuscode)
        if !response.success {
            print(response.message!)
        }
    }
    
    private func requestAccessToken(forCode accessCode: String) {
        FSOAuth.shared().requestAccessToken(forCode: accessCode,
                                            clientId: clientId,
                                            callbackURIString: callbackURIString,
                                            clientSecret: clientSecret) { [weak self] (accessToken, success, errorCode) in
                                                self?.tokenHandler?(accessToken)
        }
    }
    
    private func connectResponse(forStatusCode code: FSOAuthStatusCode) -> (success: Bool, message: String?) {
        var success = false
        var message: String?
        
        switch(code) {
        case FSOAuthStatusCode.success:
            success = true
            break
        case FSOAuthStatusCode.errorInvalidCallback:
            message = "Invalid callback URI"
            break
        case FSOAuthStatusCode.errorFoursquareNotInstalled:
            message = "Foursquare is not installed"
            break
        case FSOAuthStatusCode.errorInvalidClientID:
            message = "Invalid client id"
            break
        case FSOAuthStatusCode.errorFoursquareOAuthNotSupported:
            message = "Installed FSQ App doesn't support oauth"
            break
        }
        return (success, message)
    }
}
