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
    
    weak var delegate: FoursquareAuthorizerDelegate?
    
    func presentConnectUI(withPresenter presenter:UIViewController) -> (success: Bool, message: String?) {
        let statuscode: FSOAuthStatusCode = FSOAuth.shared().authorizeUser(usingClientId:clientId,
                                                                           nativeURICallbackString: callbackURIString,
                                                                           universalURICallbackString: nil,
                                                                           allowShowingAppStore:true,
                                                                           presentFrom:presenter)
        return connectResponse(forStatusCode: statuscode)
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
    
    private func requestAccessToken(forCode accessCode:String) {
        FSOAuth.shared().requestAccessToken(forCode: accessCode,
                                            clientId: clientId,
                                            callbackURIString: callbackURIString,
                                            clientSecret: clientSecret) { (accessToken, success, errorCode) in
                                                self.delegate?.didFinishFetchingAuthorizationToken(accessToken)
        }
    }
    
    private func connectResponse(forStatusCode code:FSOAuthStatusCode) -> (Bool, String?) {
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
