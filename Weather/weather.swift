//
//  weather.swift
//  Weather
//
//  Created by Dhruvil on 3/13/20.
//  Copyright © 2020 Dhruvil. All rights reserved.
//

import Foundation

class weatherData
{
    var weather: String
    var weekday: String
    var weekdayName = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var dateTime: String
    var icon: String
    init(weather: String, weekday: Int,dateTime: String, icon: String)
    {
        self.weather = weather
        self.weekday = weekdayName[weekday]
        self.dateTime = dateTime
        self.icon = icon
    }
}

