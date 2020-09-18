//
//  Services.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/26/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import Firebase
import CoreLocation
import GeoFire
import FirebaseAuth

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_USER_LOCATIONS = DB_REF.child("user-locations")

// MARK: - SharedService
struct Services {
    static let shared = Services()
    
    func fetchUserData(uid: String, completion: @escaping(Users) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = Users(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsersLocation(location: CLLocation, completion: @escaping(Users) -> Void) {
        let geoFire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 0.5).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(uid: uid) { (users) in
                    var user = users
                    user.location = location
                    completion(user)
                }
            })
        }
    }
}
