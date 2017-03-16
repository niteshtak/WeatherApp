//
//  WeatherTableVC.swift
//  WeatherApp
//
//  Created by Nitesh Tak on 16/03/2017.
//  Copyright © 2017 Nitesh. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableVC: UITableViewController {

    var data: [HourWeatherData] = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func setTableViewData(_ toSetWith: [HourWeatherData]) {
        data = toSetWith
        let table = self.view as! UITableView
        table.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        let forecast = data[indexPath.row]

        cell.iconImage.image = UIImage(named: forecast.icon)
        cell.timeLabel.text = getPrintDate(forecast.time as Date)
        cell.tempLabel.text = String(format: "%.1f", forecast.temperature) + " °C"
        cell.precipationConstraint.constant = CGFloat(200 * forecast.precipation)

        return cell
    }

    fileprivate func getPrintDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        if minute == 0 {
            return "\(hour):\(minute)\(minute)"
        }
        else {
            return "\(hour):\(minute)"
        }
    }
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var precipationConstraint: NSLayoutConstraint!
}
