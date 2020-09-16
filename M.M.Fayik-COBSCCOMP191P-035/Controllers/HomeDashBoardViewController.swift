//
//  HomeDashBoardViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/13/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import FirebaseAuth

private let annotationIdentifier = "UserAnnotation"

class HomeDashBoardViewController: UIViewController{

    private let mapView = MKMapView()
    private let locationManager = LocationHandling.shared.locationManager
    private var searchResults = [MKPlacemark]()
    private var route: MKRoute?
    
    let stayHomeTextView: UILabel = {
        
        let ImageText = UILabel()
        ImageText.translatesAutoresizingMaskIntoConstraints = false
        ImageText.numberOfLines = 3
        let attributedText = NSMutableAttributedString(string:  "All you need is", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        attributedText.append(NSMutableAttributedString(string: "\nStay at home", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black ]))
        
        ImageText.attributedText = attributedText
        return ImageText
    }()
    
    let stayhomeImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Home color")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let btnSafeAction: UIButton = {
        
        let button = UIButton()
        button.setTitle("Safe Actions  >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(safeActions), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let notifyImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "bell")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let notifyHomeTextView: UILabel = {
        
        let ImageText = UILabel()
        ImageText.translatesAutoresizingMaskIntoConstraints = false
        ImageText.numberOfLines = 3
        let attributedText = NSMutableAttributedString(string:  "NIBM is closed until further notice", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\nGet quick update about lecture schedule", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black ]))
        attributedText.append(NSMutableAttributedString(string: "\nstaytune with lms", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black ]))
               
        
        ImageText.attributedText = attributedText
        ImageText.textAlignment = .left
        return ImageText
    }()
    
    let arrowButton: UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ArrowButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
      //  button.addTarget(self, action: #selector(showNews), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let CaseUpdateLabel: UILabel = {
        
        let label = UILabel()
       label.numberOfLines = 3
        let attributedText = NSMutableAttributedString(string:  "University Case Update", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n1 minute ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black ]))
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        
        return label
    }()
    
    let SeeMoreButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("See more", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(showMap), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    let infectedImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bell") )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let deathsImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bell") )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let recoveredImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bell") )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let infectedTextview: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string:  "3", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)])
        textView.attributedText = attributedText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let deathsTextview: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string:  "0", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)])
        textView.attributedText = attributedText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let recoveredTextview: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string:  "10", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)])
        textView.attributedText = attributedText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let infectedLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string:  "Infected", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        uiLabel.attributedText = attributedText
        return uiLabel
    }()
    
    let deathsLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string:  "Deaths", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        uiLabel.attributedText = attributedText
        return uiLabel
    }()
    
    let recoveredLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string:  "Recovered", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        uiLabel.attributedText = attributedText
        return uiLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stayHomeImageContainerView = UIView()
        stayHomeImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stayHomeImageContainerView)
        
        let stayHomeTextContainerView = UIView()
        stayHomeTextContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stayHomeTextContainerView)
        
        let HomeNotifyContainerView = UIView()
        HomeNotifyContainerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(HomeNotifyContainerView)
        
        let HomeNotifyTextContainerView = UIView()
        HomeNotifyTextContainerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(HomeNotifyTextContainerView)
        
        let ArrowButtonContainerView = UIView()
        ArrowButtonContainerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(ArrowButtonContainerView)
        
        let CaseUpdateLabelContainerView = UIView()
        CaseUpdateLabelContainerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(CaseUpdateLabelContainerView)
        
        let SeeMoreContainerView = UIView()
        SeeMoreContainerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(SeeMoreContainerView)
        
        fetchUsers()
        AccessLocationServices()
        
        stayHomeImageContainerView.backgroundColor = .white
        stayHomeTextContainerView.backgroundColor = .white
        HomeNotifyContainerView.backgroundColor = .white
        HomeNotifyTextContainerView.backgroundColor = .white
        ArrowButtonContainerView.backgroundColor = .white
        CaseUpdateLabelContainerView.backgroundColor = .white
        SeeMoreContainerView.backgroundColor = .white
   
//      stayHomeImageContainerView.backgroundColor = .orange
//      stayHomeTextContainerView.backgroundColor = .blue
    
        stayHomeImageContainerView.addSubview(stayhomeImageView)
        stayHomeTextContainerView.addSubview(stayHomeTextView)
        stayHomeTextContainerView.addSubview(btnSafeAction)
        HomeNotifyContainerView.addSubview(notifyImageView)
        HomeNotifyTextContainerView.addSubview(notifyHomeTextView)
        ArrowButtonContainerView.addSubview(arrowButton)
        CaseUpdateLabelContainerView.addSubview(CaseUpdateLabel)
        SeeMoreContainerView.addSubview(SeeMoreButton)
        
        //corona case count down
        let infectedStackView = UIView()
        infectedStackView.translatesAutoresizingMaskIntoConstraints = false
          infectedStackView.backgroundColor = .white
        //view.addSubview(infectedStackView)
        infectedStackView.addSubview(infectedImageView)
        infectedStackView.addSubview(infectedTextview)
        infectedStackView.addSubview(infectedLabel)


        let deathsStackView = UIView()
        deathsStackView.translatesAutoresizingMaskIntoConstraints = false
          deathsStackView.backgroundColor = .white
        //view.addSubview(deathsStackView)
        deathsStackView.addSubview(deathsImageView)
        deathsStackView.addSubview(deathsTextview)
        deathsStackView.addSubview(deathsLabel)


        let recoveredStackView = UIView()
        recoveredStackView.translatesAutoresizingMaskIntoConstraints = false
          recoveredStackView.backgroundColor = .white
        //view.addSubview(recoveredStackView)
        recoveredStackView.addSubview(recoveredImageView)
        recoveredStackView.addSubview(recoveredTextview)
        recoveredStackView.addSubview(recoveredLabel)

        view.backgroundColor = .systemGray5
            
        stayHomeImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stayHomeImageContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -18).isActive = true
        stayHomeImageContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5).isActive = true
        stayHomeImageContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2).isActive = true

        stayhomeImageView.centerYAnchor.constraint(equalTo: stayHomeImageContainerView.centerYAnchor).isActive = true
        stayhomeImageView.heightAnchor.constraint(equalTo: stayHomeImageContainerView.heightAnchor, multiplier: 0.8).isActive = true
        stayhomeImageView.widthAnchor.constraint(equalTo: stayHomeImageContainerView.widthAnchor, multiplier: 0.8, constant: 25).isActive = true

        stayHomeTextContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stayHomeTextContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 18).isActive = true
        stayHomeTextContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6).isActive = true
        stayHomeTextContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2).isActive = true

        stayHomeTextView.centerYAnchor.constraint(equalTo: stayhomeImageView.centerYAnchor, constant: -15).isActive = true
        btnSafeAction.topAnchor.constraint(equalTo: stayHomeTextView.bottomAnchor, constant: 5).isActive = true
        
        HomeNotifyContainerView.topAnchor.constraint(equalTo: stayHomeImageContainerView.bottomAnchor, constant: 10).isActive = true
        HomeNotifyContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -10).isActive = true
        HomeNotifyContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.15).isActive = true
        HomeNotifyContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        notifyImageView.centerYAnchor.constraint(equalTo: HomeNotifyContainerView.centerYAnchor).isActive = true
        notifyImageView.heightAnchor.constraint(equalTo: HomeNotifyContainerView.heightAnchor, multiplier: 0.5).isActive = true
        notifyImageView.widthAnchor.constraint(equalTo: HomeNotifyContainerView.widthAnchor, multiplier: 0.5, constant: 25).isActive = true
        
        HomeNotifyTextContainerView.topAnchor.constraint(equalTo: stayHomeTextContainerView.bottomAnchor, constant: 10).isActive = true
        HomeNotifyTextContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -48).isActive = true
        HomeNotifyTextContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.77).isActive = true
        HomeNotifyTextContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        notifyHomeTextView.centerYAnchor.constraint(equalTo: notifyImageView.centerYAnchor, constant: -1).isActive = true
        
        ArrowButtonContainerView.topAnchor.constraint(equalTo: stayHomeTextContainerView.bottomAnchor, constant: 10).isActive = true
        ArrowButtonContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10).isActive = true
        ArrowButtonContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.15).isActive = true
        ArrowButtonContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        arrowButton.centerYAnchor.constraint(equalTo: ArrowButtonContainerView.centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalTo: ArrowButtonContainerView.heightAnchor, multiplier: 0.5).isActive = true
        arrowButton.widthAnchor.constraint(equalTo: ArrowButtonContainerView.widthAnchor, multiplier: 0.5, constant: 25).isActive = true
        
        CaseUpdateLabelContainerView.topAnchor.constraint(equalTo: HomeNotifyTextContainerView.bottomAnchor, constant: 10).isActive = true
        CaseUpdateLabelContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -18).isActive = true
        CaseUpdateLabelContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.71).isActive = true
        CaseUpdateLabelContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.05).isActive = true

        CaseUpdateLabel.centerYAnchor.constraint(equalTo: CaseUpdateLabelContainerView.centerYAnchor).isActive = true
        CaseUpdateLabel.centerXAnchor.constraint(equalTo: CaseUpdateLabelContainerView.centerXAnchor, constant: -39).isActive = true
        
        SeeMoreContainerView.topAnchor.constraint(equalTo: HomeNotifyTextContainerView.bottomAnchor, constant: 10).isActive = true
        SeeMoreContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 18).isActive = true
        SeeMoreContainerView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5).isActive = true
        SeeMoreContainerView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.05).isActive = true
        
        SeeMoreButton.centerYAnchor.constraint(equalTo: SeeMoreContainerView.centerYAnchor).isActive = true
        SeeMoreButton.centerXAnchor.constraint(equalTo: SeeMoreContainerView.centerXAnchor, constant: 48).isActive = true
        
        let coundDownControlStackView = UIStackView(arrangedSubviews: [infectedStackView, deathsStackView, recoveredStackView])
        coundDownControlStackView.translatesAutoresizingMaskIntoConstraints = false
        coundDownControlStackView.distribution = .fillEqually
        
        view.addSubview(coundDownControlStackView)
        
        coundDownControlStackView.topAnchor.constraint(equalTo: CaseUpdateLabelContainerView.bottomAnchor).isActive = true
        coundDownControlStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -18).isActive = true
        coundDownControlStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 18).isActive = true
        coundDownControlStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.215).isActive = true

        //infected
        infectedImageView.topAnchor.constraint(equalTo: CaseUpdateLabelContainerView.topAnchor, constant: 50).isActive = true
        infectedImageView.leadingAnchor.constraint(equalTo: CaseUpdateLabelContainerView.leadingAnchor).isActive = true
        infectedImageView.centerXAnchor.constraint(equalTo: infectedStackView.centerXAnchor).isActive = true
        infectedImageView.heightAnchor.constraint(equalTo: infectedStackView.heightAnchor, multiplier: 0.1).isActive = true

        infectedTextview.topAnchor.constraint(equalTo: infectedImageView.bottomAnchor, constant: 0).isActive = true
        infectedTextview.centerXAnchor.constraint(equalTo: infectedStackView.centerXAnchor).isActive = true

        infectedLabel.topAnchor.constraint(equalTo: infectedTextview.bottomAnchor, constant: 0).isActive = true
        infectedLabel.centerXAnchor.constraint(equalTo: infectedStackView.centerXAnchor).isActive = true
        
        //deaths
        deathsImageView.topAnchor.constraint(equalTo: CaseUpdateLabelContainerView.topAnchor, constant: 50).isActive = true
        deathsImageView.leadingAnchor.constraint(equalTo: CaseUpdateLabelContainerView.leadingAnchor).isActive = true
        deathsImageView.centerXAnchor.constraint(equalTo: deathsStackView.centerXAnchor).isActive = true
        deathsImageView.heightAnchor.constraint(equalTo: deathsStackView.heightAnchor, multiplier: 0.1).isActive = true

        deathsTextview.topAnchor.constraint(equalTo: deathsImageView.bottomAnchor, constant: 0).isActive = true
        deathsTextview.centerXAnchor.constraint(equalTo: deathsStackView.centerXAnchor).isActive = true

        deathsLabel.topAnchor.constraint(equalTo: deathsTextview.bottomAnchor, constant: 0).isActive = true
        deathsLabel.centerXAnchor.constraint(equalTo: deathsStackView.centerXAnchor).isActive = true

        //recovered
        recoveredImageView.topAnchor.constraint(equalTo: CaseUpdateLabelContainerView.topAnchor, constant: 50).isActive = true
        recoveredImageView.leadingAnchor.constraint(equalTo: CaseUpdateLabelContainerView.leadingAnchor).isActive = true
        recoveredImageView.centerXAnchor.constraint(equalTo: recoveredStackView.centerXAnchor).isActive = true
        recoveredImageView.heightAnchor.constraint(equalTo: recoveredStackView.heightAnchor, multiplier: 0.1).isActive = true

        recoveredTextview.topAnchor.constraint(equalTo: recoveredImageView.bottomAnchor, constant: 0).isActive = true
        recoveredTextview.centerXAnchor.constraint(equalTo: recoveredStackView.centerXAnchor).isActive = true

        recoveredLabel.topAnchor.constraint(equalTo: recoveredTextview.bottomAnchor, constant: 0).isActive = true
        recoveredLabel.centerXAnchor.constraint(equalTo: recoveredStackView.centerXAnchor).isActive = true
        
        let mapStackView = UIView()
        mapStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapStackView)
        
        mapStackView.addSubview(mapView)
        mapView.frame = view.frame

        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.userTrackingMode = .follow
        mapView.delegate = self

        mapStackView.topAnchor.constraint(equalTo: infectedStackView.bottomAnchor).isActive = true
        mapStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -18).isActive = true
        mapStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 18).isActive = true
       // mapStackView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.25).isActive = true

        mapView.topAnchor.constraint(equalTo: mapStackView.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: mapStackView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: mapStackView.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: mapStackView.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    @objc func safeActions() {
        let sf = SafeActionsViewController()
        sf.modalPresentationStyle = .fullScreen
        present(sf, animated: true, completion: {
            // map
        })
    }
    
    @objc func showMap() {
        
        let map = HomeViewController()
        map.modalPresentationStyle = .fullScreen
        present(map, animated: true, completion: {
            // map
        })
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
extension HomeDashBoardViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "IndexNo")
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
extension HomeDashBoardViewController {

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


