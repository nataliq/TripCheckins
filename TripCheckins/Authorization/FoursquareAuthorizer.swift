//
//  FoursquareAuthorizer.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

final class FoursquareAuthorizer {
    
    private let clientId = "SO0SBDKGOYSZCH4JMQOEHJHMNTETYOWCURGWAZ22BPHKQDWE"
    private let clientSecret = "KBYTRDYUXSUULW4P4YDELCDQVF3FZ1ZKNHLJOF0MLZ2CGUMQ"
    private let callbackURIString = "tripcheckins://foursquare"
    private var tokenHandler: ((String?) -> ())?
    
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
