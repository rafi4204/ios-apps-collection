//
//  WeatherViewState.swift
//  weatherapp
//
//  Created by rafi on 13/7/26.
//

enum WeatherViewState {
    case idle
    case loading
    case success(Weather)
    case failure(String)
}
