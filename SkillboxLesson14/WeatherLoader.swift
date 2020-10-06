//
//  WeatherLoader.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 03.10.2020.
//

import Foundation
import Alamofire

class WeatherLoader{
    
    func loadStandard(city: City, completion: @escaping (Weather) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,hourly,alerts&lang=ru&units=metric&appid=f4f83716824d96e662b7c9214adfe2d1"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed loading weather data:", error!)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }
            if let data = data,
               let weather = try? JSONDecoder().decode(Weather.self, from: data)
                {
                    DispatchQueue.main.async {
                        completion(weather)
                    }
                }
        }.resume()
    }
    
    func loadAlamofire(city: City, completion: @escaping (Weather) -> Void) {
            let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.lat)&lon=\(city.lon)&exclude=minutely,hourly,alerts&lang=ru&units=metric&appid=f4f83716824d96e662b7c9214adfe2d1"
            AF.request(urlString).responseJSON { responseJSON in
                switch responseJSON.result {
                    case .success:
                        if let data = responseJSON.data,
                           let weather = try? JSONDecoder().decode(Weather.self, from: data)
                            {
                                DispatchQueue.main.async {
                                    completion(weather)
                                }
                            }
                    case .failure(let error):
                            print("Failed loading weather data:", error)
                }
            }
        }

}



