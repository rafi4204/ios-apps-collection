//
//  WeatherViewModel.swift
//  weatherapp
//
//  Created by rafi on 13/7/26.
//

internal import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {

    private let fetchWeatherUseCase: FetchWeatherUseCase

    init(fetchWeatherUseCase: FetchWeatherUseCase) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
    }
    @Published private(set) var uiState: WeatherViewState = .idle

    func fetchWeather(lat: Double, lon: Double) async {
        self.uiState = .loading
        let weather = await self.fetchWeatherUseCase.execute(
            lat: 0,
            lon: 0
        )

        switch weather {
        case .success(let weather):
            self.uiState = .success(weather)
        case .failure:
            self.uiState = .failure("Failed to fetch weather")
        }

    }
}
