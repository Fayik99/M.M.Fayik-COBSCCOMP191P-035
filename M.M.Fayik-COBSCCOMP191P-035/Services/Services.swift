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
//let REF_TRIPS = DB_REF.child("trips")

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
            geoFire.query(at: location, withRadius: 20).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(uid: uid) { (users) in
                    var user = users
                    user.location = location
                    completion(user)
                }
            })
        }
    }
    
//    func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
//        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
//
//        let values = ["pickupCoordinates": pickupArray,
//        "destinationCoordinates": destinationArray,
//        "state": TripState.requested.rawValue] as [String : Any]
//
//        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
//    }
//
//    func observePatients(completion: @escaping(Trip) -> Void) {
//        REF_TRIPS.observe(.childAdded) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let uid = snapshot.key
//            let trip = Trip(passengerUid: uid, dictionary: dictionary)
//            completion(trip)
//        }
//    }
//
//    func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let values = ["driverUid": uid,
//                      "state": TripState.accepted.rawValue] as [String : Any]
//        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
//    }
//
//    func observeCurrentTrip(completion: @escaping(Trip) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        REF_TRIPS.child(uid).observe(.value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let uid = snapshot.key
//            let trip = Trip(passengerUid: uid, dictionary: dictionary)
//            completion(trip)
//        }
//    }
}
