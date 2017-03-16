//
//  WeatherForecastFetcher.swift
//  WeatherApp
//
//  Created by Nitesh Tak on 16/03/2017.
//  Copyright © 2017 Nitesh. All rights reserved.
//

import UIKit

class WeatherForecastFetcher: Any {

    func fetchForCoordinatesWithLatitude(_ latitude: Double, longitude: Double) -> (String, [HourWeatherData])? {
        let timestamp = Int(Date().timeIntervalSince1970) - 10800

        if let json = getJSON("https://api.forecast.io/forecast/\(Constants.APIKey)/\(latitude),\(longitude),\(timestamp)?units=si") {
            let asDictionary = parseJSON(json)
            let weatherDescription = getWeatherDescription(asDictionary)
            let hourlyWeatherData = getHourlyWeatherData(asDictionary)

            return (weatherDescription, hourlyWeatherData)
        }

        else {
            return nil
        }
    }

    fileprivate func getJSON(_ urlToRequest: String) -> Data? {
        return (try? Data(contentsOf: URL(string: urlToRequest)!))
    }

    fileprivate func parseJSON(_ inputData: Data) -> Dictionary<String, AnyObject> {
        do {
            let weatherData = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            return weatherData as! Dictionary<String, AnyObject>
        } catch {
            print("Invalid Selection.")
        }

        return Dictionary<String, AnyObject>()
    }

    fileprivate func getWeatherDescription(_ data: Dictionary<String, AnyObject>) -> String {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        let description = hourly["summary"] as! String
        return "\(description)"
    }

    fileprivate func getHourlyWeatherData(_ data: Dictionary<String, AnyObject>) -> [HourWeatherData] {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        let data = hourly["data"] as! [AnyObject]
        var asHourData: [HourWeatherData] = []

        for forecast in data {
            if let parsed = sortByHourAndConvertToWeatherData(forecast) {
                asHourData.append(parsed)
            }
        }

        return asHourData
    }

    fileprivate func sortByHourAndConvertToWeatherData(_ forecast: AnyObject) -> HourWeatherData? {

        let icon = forecast["icon"] as! String
        let forecastTime = Date(timeIntervalSince1970: TimeInterval(forecast["time"] as! Int))
        let temperature = forecast["temperature"] as! Double
        let precipation = forecast["precipIntensity"] as? Double

        return HourWeatherData(icon: icon, time: forecastTime, temperature: temperature, precipation: precipation)
    }
}

class HourWeatherData {
    var icon: String = ""
    var time: Date
    var temperature: Double = 0.0
    var precipation: Double = 0.0

    init(icon: String, time: Date, temperature: Double, precipation: Double?) {
        self.icon = icon
        self.time = time
        self.temperature = temperature
        if let prec = precipation {
            self.precipation = prec
        }
    }
}
