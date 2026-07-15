//
//  WeatherView.swift
//  weatherapp
//
//  Created by rafi on 13/7/26.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel: WeatherViewModel
    
    // Coordinates for Dhaka, Bangladesh default setup
    private let latitude = 23.8103
    private let longitude = 90.4125
    
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.uiState {
                case .idle:
                    Text("Tap fetch to check weather updates.")
                case .loading:
                    ProgressView("Fetching current conditions...")
                case .success(let weather):
                    WeatherInfoCard(weather: weather)
                case .failure(let errorString):
                    Text("Error: \(errorString)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button("Refresh Weather Data") {
                    Task {
                        await viewModel.fetchWeather(lat: latitude, lon: longitude)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 24)
            }
            .padding()
            .navigationTitle("Clean Weather")
            // Safely fires up initial network fetch matching runtime visibility lifecycle events
            .task {
                await viewModel.fetchWeather(lat: latitude, lon: longitude)
            }
        }
    }
}

// UI Sub-component extraction
struct WeatherInfoCard: View {
    let weather: Weather
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(Int(weather.temperature))°C")
                .font(.system(size: 64, weight: .bold))
            Text("Wind Speed: \(weather.windSpeed) km/h")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Updated at: \(weather.time)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}


#Preview{
    
    WeatherInfoCard(weather: Weather(
        temperature: 25.0,
        windSpeed: 12.3,
        time: "2023-10-10T14:30:00Z"
    ))
}

