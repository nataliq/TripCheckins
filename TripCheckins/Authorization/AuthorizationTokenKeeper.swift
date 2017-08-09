//
//  File.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

protocol AuthorizationTokenKeeper {
    func authorizationToken() -> String?
    func persistAuthorizationToken(_ token:String?)
}
