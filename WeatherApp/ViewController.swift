//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nitesh Tak on 16/03/2017.
//  Copyright © 2017 Nitesh. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var forecastSummary: UILabel!

    var locationManager: CLLocationManager?
    var oldCoords: (Double, Double) = (0.0, 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }

    fileprivate func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
    }

    fileprivate func setViewDataFromCoordinates(_ lat: Double, lon: Double) {
        for child in self.childViewControllers {
            if child.isKind(of: WeatherTableVC.self) {
                let controller = child as! WeatherTableVC

                if let (summary, data) = self.fetchForecastData(lat, lon: lon) {
                    forecastSummary.text = summary
                    controller.setTableViewData(data)
                }
            }

        }
    }

    fileprivate func fetchForecastData(_ lat: Double, lon: Double) -> (String, [HourWeatherData])? {
        let fetcher = WeatherForecastFetcher()
        return fetcher.fetchForCoordinatesWithLatitude(lat, longitude: lon)
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationObj = (locations as NSArray).lastObject as! CLLocation
        let coord = locationObj.coordinate

        let lat = coord.latitude as Double
        let lon = coord.longitude as Double

        if (lat != oldCoords.0 && lon != oldCoords.1) {
            setViewDataFromCoordinates(coord.latitude as Double, lon: coord.longitude as Double)
            oldCoords = (lat, lon)
        }
    }
}

