//
//  ViewController.swift
//  Altitudo
//
//  Created by Jamario Davis on 7/10/19.
//  Copyright © 2019 KAYCAM. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet private var gradientView: GradientView!
    @IBOutlet private var gpsAltitudeLabel: UILabel!
    @IBOutlet private var altitudeMarginOfErrorLabel: UILabel!
    @IBOutlet private var altimiterLabel: UILabel!
    @IBOutlet private var locationTitleLabel: UILabel!
    @IBOutlet private var gpsLocationLabel: UILabel!
    
    private var backgroundImageView = UIImageView()
    let locationManager = CLLocationManager()
    let altimeter = CMAltimeter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        checkLocationServices()
        startTrackingAltitudeChanges()
        gpsLocationLabel.text = "ready!"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradientView.setupGradient()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        altimeter.stopRelativeAltitudeUpdates()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            
            break
        case .authorizedAlways:
            break
        }
    }
    func setBackground() {
        backgroundImageView             = UIImageView(frame: CGRect.zero)
        backgroundImageView.image       = #imageLiteral(resourceName: "stairway")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints                        = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func startTrackingAltitudeChanges() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            return
        }
        
        let queue = OperationQueue()
        queue.qualityOfService = .background
        altimeter.startRelativeAltitudeUpdates(to: queue) { (altimeterData, error) in
            if let altimeterData = altimeterData {
                DispatchQueue.main.async {
                    let relativeAltitude        = altimeterData.relativeAltitude as! Double
                    let roundedAltitude         = Int(relativeAltitude.rounded(toDecimalPlaces: 0))
                    self.altimiterLabel.text    = "\(roundedAltitude)m"
                }
            }
        }
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        gpsLocationLabel.text = "\(first.coordinate.longitude) | \(first.coordinate.latitude)"
        guard let location = locations.last else { return }
        let altitude = location.altitude.rounded(toDecimalPlaces: 0)
        gpsAltitudeLabel.text = "\(Int(altitude))m"
        altitudeMarginOfErrorLabel.text = "+/-   \(location.verticalAccuracy)m"
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


