//
//  UserDefaults+AuthorizationTokenKeeper.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

let authorizationTokenKey = "authToken"

extension UserDefaults: AuthorizationTokenKeeper {
    
    func authorizationToken() -> String? {
        return value(forKey: authorizationTokenKey) as? String
    }
    
    func persistAuthorizationToken(_ token: String?) {
        setValue(token, forKey: authorizationTokenKey)
    }
    
    
}
