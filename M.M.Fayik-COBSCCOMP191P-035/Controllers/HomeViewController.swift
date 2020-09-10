//
//  HomeViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import FirebaseAuth

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "UserAnnotation"

private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandling.shared.locationManager
    
    private let inputActivationUIView = LocationInputActivation ()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private var actionButtonConfig = ActionButtonConfiguration()
    private var route: MKRoute?
    
    private var users: Users? {
        didSet {
            locationInputView.users = users
            if users?.accountType == .Student || users?.accountType == .Staff {
                fetchUsers()
                configureLocationInputActivationView()
            } else {
                print("Invalid acoountType")
            }
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycale
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIsUserLoggedIn()
        //signOut()
        AccessLocationServices()
        
       view.backgroundColor = .white
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch actionButtonConfig {
        case .showMenu:
            print("DEBUG: Show menu")
            break
        case .dismissActionView:
            removeAnnotationsAndOverlays()
            mapView.showAnnotations(mapView.annotations, animated: true)
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationUIView.alpha = 1
                self.configureActionButton(config: .showMenu)
            }
            break
        }
    }
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Services.shared.fetchUserData(uid: currentUid) { (users) in
            self.users = users
        }
    }
    
    func fetchUsers() {
        guard let location = locationManager?.location else { return }
        Services.shared.fetchUsersLocation(location: location) { (user) in
            guard let coordinate = user.location?.coordinate else { return }
            let annotation = UserAnnotation(uid: user.uid, coordinate: coordinate)
            
            var userIsVisible: Bool {
                
                return self.mapView.annotations.contains { (annotation) -> Bool in
                    guard let userAnno = annotation as? UserAnnotation else { return false }
                    
                    if userAnno.uid == user.uid {
                        userAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    
                    return false
                }
            }
            
            if !userIsVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    func checkIsUserLoggedIn() {
        if(Auth.auth().currentUser?.uid == nil) {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configure()
        }
    }
    
//        func signOut() {
//            do {
//                try Auth.auth().signOut()
//                DispatchQueue.main.async {
//                    let nav = UINavigationController(rootViewController: LoginViewController())
//                    nav.modalPresentationStyle = .fullScreen
//                    self.present(nav, animated: true, completion: nil)
//                }
//            } catch {
//                print("DEBUG: Sign out error")
//            }
//        }
    
    // MARK: - Helper Function
    
    fileprivate func configureActionButton(config: ActionButtonConfiguration) {
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
        case .dismissActionView:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
    func configure() {
        configureUi()
        fetchUserData()
      //  fetchUsers()
    
    }
    
    func configureUi() {
        confugireMapView()
      
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            paddingTop: 16, paddingLeft: 20, width: 30, height: 30)
        
        
        configureTableView()

    }
    
    func configureLocationInputActivationView() {
        view.addSubview(inputActivationUIView)
        inputActivationUIView.centerX(inView: view)
        inputActivationUIView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationUIView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationUIView.alpha = 0
        inputActivationUIView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationUIView.alpha = 1
        }
    }
    
    func confugireMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView () {
        
        locationInputView.delegate = self
        
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.addSubview(tableView)
    }
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
            
        }, completion: completion)
    }
}

// MARK: - MapView Helper Functions
private extension HomeViewController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            response.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            
            completion(results)
        }
    }
    
    func generatePolyline(toDestination destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { (response, error) in
            guard let response = response else { return }
            
            self.route = response.routes[0]
            guard let polyline = self.route?.polyline else { return }
            self.mapView.addOverlay(polyline)
        }
    }
    
    func removeAnnotationsAndOverlays() {
        mapView.annotations.forEach { (annotation) in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "icons8-user-100")
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.strokeColor = .mainBlueTint
            lineRenderer.lineWidth = 4
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
}

// MARK: - LocationServices
extension HomeViewController {
    
    func  AccessLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        default:
            break
        }
    }
}

// MARK: - LocationInputActivationUIViewDelegate
 extension HomeViewController: LocationInputActivationDelegate {
    func presentLocationInputView() {
        inputActivationUIView.alpha = 0
        configureLocationInputView()
    }

}

// MARK: - LocationInputViewDelegate
extension HomeViewController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.5) {
                self.inputActivationUIView.alpha = 1
            }
        }
    }
}

// MARK: - UITableViewDelegate/DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Searching places"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTableViewCell
        
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        
        configureActionButton(config: .dismissActionView)
        
        let destination = MKMapItem(placemark: selectedPlacemark)
        generatePolyline(toDestination: destination)
        
        dismissLocationView { _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: UserAnnotation.self) })
            self.mapView.zoomToFit(annotations: annotations)
        }
        
    }
}




























//import UIKit
//import MapKit
//import Firebase
//import FirebaseAuth
//import FirebaseCore
//
//private let reuseIdentifier = "LocationCell"
//private let annotationIdentifier = "UserAnnotation"
//
//private enum ActionButtonConfiguration {
//    case showMenu
//    case dismissActionView
//
//    init() {
//        self = .showMenu
//    }
//}
//
//class HomeViewController: UIViewController {
//
//    private let locationManager = LocationHandling.shared.locationManager
//    private let mapView = MKMapView()
//
//    private let inputActivation = LocationInputActivation()
//    private let locationInputView = LocationInputView()
//    private let tableView = UITableView()
//    private var searchResults = [MKPlacemark]()
//    private final let locationInputViewHeight: CGFloat = 200
//    private var actionButtonConfig = ActionButtonConfiguration()
//    private var route: MKRoute?
//
//
//    private var users: Users? {
//        didSet {
//            locationInputView.users = users
//            if users?.accountType == .Student || users?.accountType == .Staff {
//                fetchusers()
//                configureLocationInputActivationView()
//              //  observeCurrentTrip()
//             }
//              else {
//                  print("Invalid accountType")
//         }
//
//        }
//    }
//
//    private let actionButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//     //   configureNavigationBar()
//        checkIsUserLoggedIn()
//        //signOut()
//
//        AccessLocationServices()
//        view.backgroundColor = .white
//    }
//
//    @objc func actionButtonPressed() {
//           switch actionButtonConfig {
//           case .showMenu:
//               print("DEBUG: Show menu")
//               break
//           case .dismissActionView:
//               removeAnnotationsAndOverlays()
//               mapView.showAnnotations(mapView.annotations, animated: true)
//
//               UIView.animate(withDuration: 0.3) {
//                   self.inputActivation.alpha = 1
//                   self.configureActionButton(config: .showMenu)
//                 //self.animateRideActionView(shouldShow: false)
//               }
//               break
//           }
//       }
//
//    func fetchUserData() {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        Services.shared.fetchUserData(uid: currentUid) { (users) in
//            self.users = users
//        }
//    }
//
//    func fetchusers() {
//        guard let location = locationManager?.location else { return }
//        Services.shared.fetchUsersLocation(location: location) { (user) in
//            guard let coordinate = user.location?.coordinate else { return }
//            let annotation = UserAnnotation(uid: user.uid, coordinate: coordinate)
//
//            var userIsVisible: Bool {
//
//                return self.mapView.annotations.contains { (annotation) -> Bool in
//                    guard let UserAnno = annotation as? UserAnnotation else { return false }
//
//                    if UserAnno.uid == user.uid {
//                        UserAnno.updateAnnotationPosition(withCoordinate: coordinate)
//                        return true
//                    }
//
//                    return false
//                }
//            }
//
//            if !userIsVisible {
//                self.mapView.addAnnotation(annotation)
//            }
//        }
//    }
//
//    func checkIsUserLoggedIn() {
//        if(Auth.auth().currentUser?.uid == nil) {
//            DispatchQueue.main.async {
//                let nav = UINavigationController(rootViewController: LoginViewController())
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
//            }
//        }  else {
//            configure()
//        }
//
//    }
//
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            DispatchQueue.main.async {
//                let nav = UINavigationController(rootViewController: LoginViewController())
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
//            }
//        } catch {
//            print("DEBUG: sign out error")
//        }
//    }
//
//    fileprivate func configureActionButton(config: ActionButtonConfiguration) {
//        switch config {
//        case .showMenu:
//            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
//            self.actionButtonConfig = .showMenu
//        case .dismissActionView:
//            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
//            actionButtonConfig = .dismissActionView
//        }
//    }
//
//    func configure() {
//         configureUi()
//         fetchUserData()
//     }
//
//    func configureUi() {
//        configureMapView()
//
//        view.addSubview(actionButton)
//        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
//                            paddingTop: 16, paddingLeft: 20, width: 30, height: 30)
//
//
//        configTableView()
//    }
//
//    func configureLocationInputActivationView() {
//
//        view.addSubview(inputActivation)
//        inputActivation.centerX(inView: view)
//        inputActivation.setDimensions(height: 50, width: view.frame.width - 64)
//        inputActivation.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
//        inputActivation.alpha = 0
//        inputActivation.delegate = self
//
//        UIView.animate(withDuration: 2) {
//            self.inputActivation.alpha = 1
//        }
//    }
//
//    func configureMapView()
//      {
//          view.addSubview(mapView)
//          mapView.frame = view.frame
//
//          mapView.showsUserLocation = true
//          mapView.userTrackingMode = .follow
//          mapView.delegate = self
//      }
//
//    func configureLocationInputView () {
//
//        view.addSubview(locationInputView)
//        view.addSubview(locationInputView)
//        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
//        locationInputView.alpha = 0
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.locationInputView.alpha = 1
//        }) { _ in
//            UIView.animate(withDuration: 0.3) {
//                self.tableView.frame.origin.y = self.locationInputViewHeight
//            }
//        }
//    }
//
//    func configTableView() {
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.rowHeight = 60
//        tableView.tableFooterView = UIView()
//
//        let height = view.frame.height - locationInputViewHeight
//        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
//
//        view.addSubview(tableView)
//    }
//
//    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.locationInputView.alpha = 0
//            self.tableView.frame.origin.y = self.view.frame.height
//            self.locationInputView.removeFromSuperview()
//
//        }, completion: completion)
//    }
//
////    func  configureNavigationBar()
////    {
////        navigationController?.navigationBar.isHidden = true
////        navigationController?.navigationBar.barStyle = .black
////    }
//}
//
//// MARK: - MapView Helper Functions
//private extension HomeViewController {
//    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
//        var results = [MKPlacemark]()
//
//        let request = MKLocalSearch.Request()
//        request.region = mapView.region
//        request.naturalLanguageQuery = naturalLanguageQuery
//
//        let search = MKLocalSearch(request: request)
//        search.start { (response, error) in
//            guard let response = response else { return }
//
//            response.mapItems.forEach({ item in
//                results.append(item.placemark)
//            })
//
//            completion(results)
//        }
//    }
//
//    func generatePolyline(toDestination destination: MKMapItem) {
//        let request = MKDirections.Request()
//        request.source = MKMapItem.forCurrentLocation()
//        request.destination = destination
//        request.transportType = .automobile
//
//        let directionRequest = MKDirections(request: request)
//        directionRequest.calculate { (response, error) in
//            guard let response = response else { return }
//
//            self.route = response.routes[0]
//            guard let polyline = self.route?.polyline else { return }
//            self.mapView.addOverlay(polyline)
//        }
//    }
//
//    func removeAnnotationsAndOverlays() {
//        mapView.annotations.forEach { (annotation) in
//            if let anno = annotation as? MKPointAnnotation {
//                mapView.removeAnnotation(anno)
//            }
//        }
//
//        if mapView.overlays.count > 0 {
//            mapView.removeOverlay(mapView.overlays[0])
//        }
//    }
//}
//
//// MARK: - MKMapViewDelegate
//extension HomeViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? UserAnnotation {
//            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            view.image = #imageLiteral(resourceName: "icons8-name-100")
//            return view
//        }
//
//        return nil
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let route = self.route {
//            let polyline = route.polyline
//            let lineRenderer = MKPolylineRenderer(overlay: polyline)
//            lineRenderer.strokeColor = .mainBlueTint
//            lineRenderer.lineWidth = 4
//            return lineRenderer
//        }
//        return MKOverlayRenderer()
//    }
//}
//
//
//// MARK: - LocationServices
//extension HomeViewController {
//
//    func AccessLocationServices() {
//
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined:
//            locationManager?.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            break
//        case .authorizedWhenInUse:
//            locationManager?.requestAlwaysAuthorization()
//        case .authorizedAlways:
//            locationManager?.startUpdatingLocation()
//            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        default:
//            break
//        }
//    }
//}
//
//extension HomeViewController: LocationInputActivationDelegate {
//    func presentLocationInputView() {
//        inputActivation.alpha = 0
//        configureLocationInputView()
//    }
//}
//
//// MARK: - LocationInputViewDelegate
//extension HomeViewController: LocationInputViewDelegate {
//    func executeSearch(query: String) {
//       // print("DEBUG: query is \(query)")
//        searchBy(naturalLanguageQuery: query) { (results) in
//            self.searchResults = results
//            self.tableView.reloadData()
//        }
//    }
//
//    func dismissLocationInputView() {
//        dismissLocationView { _ in
//            UIView.animate(withDuration: 0.5) {
//                self.inputActivation.alpha = 1
//            }
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate/DataSource
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "hello"
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 2 : searchResults.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTableViewCell
//
//        //        if indexPath.section == 0 {
//        //            cell.placemark = savedLocations[indexPath.row]
//        //        }
//
//        if indexPath.section == 1 {
//            cell.placemark = searchResults[indexPath.row]
//        }
//
//        return cell
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////        let selectedPlacemark = searchResults[indexPath.row]
////
////        configureActionButton(config: .dismissActionView)
////
////        let destination = MKMapItem(placemark: selectedPlacemark)
////        generatePolyline(toDestination: destination)
////
////        dismissLocationView { _ in
////            let annotation = MKPointAnnotation()
////            annotation.coordinate = selectedPlacemark.coordinate
////            self.mapView.addAnnotation(annotation)
////            self.mapView.selectAnnotation(annotation, animated: true)
////
////            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: UserAnnotation.self) })
////            self.mapView.zoomToFit(annotations: annotations)
////
////           // self.animateRideActionView(shouldShow: true, destination: selectedPlacemark)
////        }
////
////    }
//}

