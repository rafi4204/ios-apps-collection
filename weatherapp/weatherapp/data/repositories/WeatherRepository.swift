//
//  WeatherRepository.swift
//  weatherapp
//
//  Created by rafi on 12/7/26.
//

protocol WeatherRepository{
    func getCurrentWeather(lat: Double, lon:Double) async -> Result<Weather, Error>
}
