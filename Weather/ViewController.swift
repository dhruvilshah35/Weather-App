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
    @IBOutlet weak var display: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var weather = [weatherData]()
    var icon = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        errorMessage.isHidden = true
        display.isHidden = false
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        icon.removeAll()
        weather.removeAll()
        display.isHidden = true
        tableView.isHidden = false
        errorMessage.isHidden = true
        fetchDataFromServer()
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func dateFormat(_ input: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:input)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    func fetchDataFromServer() {
        let session = URLSession.shared
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(inputTextField.text!)&appid=315a58414168af73afb3325145ea205b") else {
                display.isHidden = false
                tableView.isHidden = true
                errorMessage.isHidden = false
            errorMessage.text = "Error: city not found"
                return
            }
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print("Error in fetching films: \(error)")
                self.display.isHidden = false
                self.tableView.isHidden = true
                self.errorMessage.isHidden = false
                self.errorMessage.text = "Error: \(error)"
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to fetch response, unexpected status code: \(String(describing: response))")
                DispatchQueue.main.async {
                    self.display.isHidden = false
                    self.tableView.isHidden = true
                    self.errorMessage.isHidden = false
                    self.errorMessage.text = "Error!! PLease try again"
                }
                return
            }
             if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let jsonDict: NSDictionary = json as! NSDictionary
                        let list = jsonDict["list"] as! [NSDictionary]
                        for element in list {
                            let weathrInfo = element["weather"] as! [NSDictionary]
                            let info = weathrInfo[0]["description"] as! String
                            let icon = weathrInfo[0]["icon"] as! String
                            let dateTime = element["dt_txt"] as! String
                            let dateFormatted = self.dateFormat(dateTime)
                            if let weekday = self.getDayOfWeek(dateFormatted) {
                                self.weather.append(weatherData(weather: info, weekday: weekday,dateTime: dateTime,icon: icon))
                            }
                        }
                        DispatchQueue.main.async {
                            self.fetchIconFromServer()
                            self.tableView.reloadData()
                        }
                    } catch {
                        self.display.isHidden = false
                        self.tableView.isHidden = true
                        print("Error")
                        return
                    }
            }
        })
        task.resume()
    }
    func fetchIconFromServer()
    {
        for value in weather
        {
            let session = URLSession.shared
            guard let url = URL(string:"http://openweathermap.org/img/wn/\(value.icon)@2x.png") else {
                print("E")
                return
            }
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                if let error = error {
                    print("Error in fetching films: \(error)")
                    self.display.isHidden = false
                    self.tableView.isHidden = true
                    self.errorMessage.isHidden = false
                    self.errorMessage.text = "Error: \(error)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Failed to fetch response, unexpected status code: \(String(describing: response))")
                    DispatchQueue.main.async {
                        self.display.isHidden = false
                        self.tableView.isHidden = true
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = "Error!! PLease try again"
                    }
                    return
                }
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.icon.append(image)
                        print("hi")
                    }}
            })
            task.resume()
        }
        
    }
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 90
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableViewCell
        let weatherInfo = weather[indexPath.row]
        cell.weather.text = weatherInfo.weather
        cell.weekday.text = weatherInfo.weekday
        cell.dateTime.text = weatherInfo.dateTime
        return cell
    }
}
