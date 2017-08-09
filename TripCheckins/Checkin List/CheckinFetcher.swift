//
//  CheckinFetcher.swift
//  TripCheckins
//
//  Created by Nataliya  on 8/8/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

class CheckinFetcher {
    let endpointAuthTokenPrefix = "https://api.foursquare.com/v2/users/self/checkins?v=20170808&oauth_token="
    
    var getCurrentUserCheckinsURL: URL? {
        return URL(string:endpointAuthTokenPrefix + authorizationToken)
    }
    
    let authorizationToken: String
    
    init(authorizationToken: String) {
        self.authorizationToken = authorizationToken
    }
    
    func fetch(with completion:@escaping ([String:Any]) -> Void) {
        guard let url = getCurrentUserCheckinsURL else {
            assertionFailure("cannot create url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error when getting checkins: \(error!.localizedDescription)")
                completion([:])
                return
            }
            do {
                guard let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    completion([:])
                    return
                }
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch  {
                print("error trying to convert data to JSON")
                completion([:])
                return
            }
        }
        task.resume()
    }
}
