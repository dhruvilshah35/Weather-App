//
//  ResponseAPI.swift
//  Weather
//
//  Created by Dhruvil on 3/14/20.
//  Copyright © 2020 Dhruvil. All rights reserved.
//

import Foundation

struct weatherSummary: Codable {
    let list: [dateData]?
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}

struct dateData: Codable {
    let date: String
    let weather : [weatherInfo]?
    
    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case weather
    }
}

struct weatherInfo: Codable {
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}
