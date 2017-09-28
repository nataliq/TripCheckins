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

final class FoursquareAuthorizer {
    
    private let clientId: String
    private let clientSecret: String
    private let callbackURIString: String
    
    convenience init?() {
        guard let plistPath = Bundle.main.path(forResource: "foursquare_api_configuration", ofType: "plist"),
            let configuration = NSDictionary(contentsOfFile: plistPath) as? [String: String],
            let clientId = configuration["client_id"],
            let clientSecret = configuration["client_secret"],
            let callbackURIString = configuration["callback_uri"] else {
                return nil
        }
        self.init(clientId: clientId, clientSecret: clientSecret, callbackURIString: callbackURIString)
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
