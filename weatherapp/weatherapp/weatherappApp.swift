//
//  weatherappApp.swift
//  weatherapp
//
//  Created by rafi on 12/7/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    // Structural manual composition root dependency injection chain
    private var weatherViewModel: WeatherViewModel {
        let repo = WeatherRepositoryImpl()
        let useCase = FetchWeatherUseCase(weatherRepository: repo)
        return WeatherViewModel(fetchWeatherUseCase: useCase)
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: weatherViewModel)
        }
    }
}
