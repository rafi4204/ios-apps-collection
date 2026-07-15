//
//  FetchWeatherUseCase.swift
//  weatherapp
//
//  Created by rafi on 12/7/26.
//

struct FetchWeatherUseCase {
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func execute(lat: Double, lon: Double) async -> Result<Weather,Error> {
        return await weatherRepository.getCurrentWeather(lat: lat, lon: lon)
    }
}
