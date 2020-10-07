//
//  ViewController.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 30.09.2020.
//

import UIKit
import Alamofire
import RealmSwift

class ViewController: UIViewController {
    
    var weather: Weather?

    @IBOutlet weak var forcastTableView: UITableView!
    
    @IBOutlet weak var updateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var weatherSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.ident)
        weatherSwitch.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        if let city = CityData.get(name: "Москва") {
            loadRealmData(city: city)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configLabels()
        if let city = CityData.get(name: "Москва") {
            loadWeather(city: city, loader: true)
        }
    }
    
    private func loadWeather(city: City?, loader : Bool) {
        if let city = city {
            if loader {
                WeatherLoader().loadStandard(city: city) { weather in
                    self.markDataWeather(city: city, weather: weather)
                    self.configLabels()
                    self.forcastTableView.reloadData()
                    self.writeRealmData()
                   }
            } else {
                WeatherLoader().loadAlamofire(city: city) { weather in
                    self.markDataWeather(city: city, weather: weather)
                    self.configLabels()
                    self.forcastTableView.reloadData()
                    self.writeRealmData()
                   }
            }
        }
    }
    
    private func markDataWeather (city: City, weather: Weather) {
        deleteMarkedData(city: city)
        weather.lastUpdate = Date()
        weather.city = city.name
        for day in weather.daily {
            day.city = city.name
            for w in day.weather {
                w.city = city.name
            }
            day.temp?.city = city.name
        }
        if let current = weather.current {
            current.city = city.name
            for w in current.weather {
                w.city = city.name
            }
        }
        self.weather = weather
    }
    
    private func deleteMarkedData (city: City) {
        let realmInstance = try! Realm()
        try! realmInstance.write {
            realmInstance.delete(realmInstance.objects(Weather.self).filter("city == \"\(city.name)\""))
            realmInstance.delete(realmInstance.objects(WeatherElement.self).filter("city == \"\(city.name)\""))
            realmInstance.delete(realmInstance.objects(Temp.self).filter("city == \"\(city.name)\""))
            realmInstance.delete(realmInstance.objects(Daily.self).filter("city == \"\(city.name)\""))
            realmInstance.delete(realmInstance.objects(Current.self).filter("city == \"\(city.name)\""))
        }
    }
    
    private func loadRealmData(city: City?) {
        if let city = city {
            weather = try? Realm().object(ofType: Weather.self, forPrimaryKey: city.name)
        }
    }
    
    private func writeRealmData() {
            let realmInstance = try! Realm()
            try! realmInstance.write {
                if let weather = weather {
                    realmInstance.add(weather, update: .modified)
                }
            }
    }
    
    private func configLabels() {
        if let lastUpdate = weather?.lastUpdate,
           let city = weather?.city,
           let temp = weather?.current?.temp,
           let description = weather?.current?.weather.first?.weatherDescription,
           let pressure = weather?.current?.pressure,
           let humidity = weather?.current?.humidity,
           let wind = weather?.current?.windSpeed
           {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            formatter.locale = Locale(identifier: "ru_RU")
            updateLabel.text = "Обновлено: \(formatter.string(from: lastUpdate))"
            cityLabel.text = city
            temperatureLabel.text = "\(temp.roundTo(places: 1))° C"
            descriptionLabel.text = String(description)
            pressureLabel.text = "Давление: \(pressure) гПа"
            humidityLabel.text = "Влажность: \(humidity)%"
            windLabel.text = "Ветер: \(wind.roundTo(places: 1)) м/с"
        }
    }
    
    private func loadImage(icon: String?) -> UIImage? {
        var image : UIImage?
        let sem = DispatchSemaphore(value: 0)
        guard let icon = icon,
              let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { sem.signal(); return nil }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                sem.signal()
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                sem.signal()
                return
            }
            if let data = data {
                image = UIImage(data: data)
                sem.signal()
            }
        }.resume()
        sem.wait()
    return image
    }
    
    private func convertDate(date: Int) -> String {
        let epochDate = Date(timeIntervalSince1970: TimeInterval(date))
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: epochDate)
        let currentMonth = calendar.component(.month, from: epochDate)
    return "\(currentDay)/\(currentMonth)"
    }
    
    @objc func changeValue(sender: UISwitch) {
        if sender.isOn {
            if let city = CityData.get(name: "Хабаровск") {
                loadRealmData(city: city)
                configLabels()
                forcastTableView.reloadData()
                loadWeather(city: city, loader: false)
            }
        }
        else {
            if let city = CityData.get(name: "Москва") {
                loadRealmData(city: city)
                configLabels()
                forcastTableView.reloadData()
                loadWeather(city: city, loader: true)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        if let weather = self.weather?.daily[indexPath.row + 1],
           let temp = weather.temp {
            cell.configure(date: convertDate(date: weather.unixDate),
                           icon: loadImage(icon: weather.weather.first?.icon),
                           pressure: "Давление: \(weather.pressure) гПа",
                           humidity: "Влажность: \(weather.humidity)%",
                           wind: "Ветер: \(weather.windSpeed.roundTo(places: 1)) м/с",
                           dayTemp: "\(temp.day.roundTo(places: 1))° C",
                           nightTemp: "\(temp.night.roundTo(places: 1))° C")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


