//
//  Weather.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 03.10.2020.
//

import Foundation

struct Weather: Codable {
    let current: Current
    let daily: [Daily]
    
    struct Current: Codable {
        let temp, windSpeed: Double
        let pressure, humidity, unixDate: Int
        let weather: [WeatherElement]
        
        struct WeatherElement: Codable {
            let weatherDescription, icon: String

            enum CodingKeys: String, CodingKey {
                case weatherDescription = "description"
                case icon
            }
        }

        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity, weather
            case windSpeed = "wind_speed"
            case unixDate = "dt"
        }
    }
    
    struct Daily: Codable {
        let temp: Temp
        let pressure, humidity, unixDate: Int
        let windSpeed: Double
        let weather: [WeatherElement]
        
        struct Temp: Codable {
            let day, night: Double
        }
        struct WeatherElement: Codable {
            let weatherDescription, icon: String

            enum CodingKeys: String, CodingKey {
                case weatherDescription = "description"
                case icon
            }
        }

        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity, weather
            case windSpeed = "wind_speed"
            case unixDate = "dt"
        }
    }

    enum CodingKeys: String, CodingKey {
        case current, daily
    }
}

