//
//  NetworkManager.swift
//  Weather
//
//  Created by Dhruvil on 3/14/20.
//  Copyright © 2020 Dhruvil. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let domainUrlString = "http://api.openweathermap.org/data/2.5/forecast?q="
    
    func fetchWeather(city: String,completionHandler: @escaping ([dateData]) -> Void) {
        
        let url = URL(string: domainUrlString + city + "&appid=315a58414168af73afb3325145ea205b")
        
        guard let weatherurl = url else {
            print("Incorrect Url: \(String(describing: url))")
            return
        }
        
        let task = URLSession.shared.dataTask(with: weatherurl, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error in fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to fetch response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data {
                do {
                    let weathersummary = try JSONDecoder().decode(weatherSummary.self, from: data)
                    completionHandler(weathersummary.list ?? [])
                }
                catch let jsonError{
                    print("Error in decoding JSON: \(jsonError)")
                }
            }
        })
        
        task.resume()
    }
    
    func fetchIcon(icons: String,completionHandler: @escaping (Data) -> Void) {
        
        let url = URL(string: "http://openweathermap.org/img/wn/\(icons)@2x.png")
        
        guard let iconurl = url else {
            print("Incorrect Url: \(String(describing: url))")
            return
        }
        
        let task = URLSession.shared.dataTask(with: iconurl, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error in fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to fetch response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data {
                completionHandler(data)
            }
        })
        task.resume()
    }
}
