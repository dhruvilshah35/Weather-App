//
//  ViewController.swift
//  Weather
//
//  Created by Dhruvil on 3/12/20.
//  Copyright © 2020 Dhruvil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    var weatherData = [dateData]()
    let networkManager = NetworkManager.shared
    var iconImage = [Data]()
    var weekdayName = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        iconImage.removeAll()
        weatherData.removeAll()
        self.tableView.separatorStyle = .singleLine
        networkManager.fetchWeather(city: inputTextField.text!) { [weak self] (weatherData) in
            guard let self = self else {
                return
            }
            self.weatherData = weatherData
            for i in self.weatherData
            {
                self.networkManager.fetchIcon(icons:(i.weather?[0].icon)!) { [weak self] (icondata) in
                    guard let self = self else {
                        return
                    }
                    self.iconImage.append(icondata)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd ha"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func dateFormat(_ input: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from:input)!
        dateFormatter.dateFormat = "yyyy-MM-dd ha"
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
   
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 90
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableViewCell
        cell.layer.cornerRadius = 5
        let data = weatherData[indexPath.row]
        cell.weekday.text = weekdayName[getDayOfWeek(dateFormat(data.date)) ?? 0]
        cell.dateTime.text = dateFormat(data.date)
        cell.weather.text = data.weather?[0].description
        cell.icon.setImage(UIImage(data: iconImage[indexPath.row])?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cell
    }
}
