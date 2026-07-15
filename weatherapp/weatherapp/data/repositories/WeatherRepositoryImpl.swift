//
//  WeatherRepositoryImpl.swift
//  weatherapp
//
//  Created by rafi on 12/7/26.
//

import Foundation

class WeatherRepositoryImpl: WeatherRepository {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCurrentWeather(lat: Double, lon: Double) async -> Result<Weather, any Error> {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,wind_speed_10m"
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(NetworkError.invalidResponse)
            }
            let decoder = JSONDecoder()
            let dto = try decoder.decode(OpenMeteoResponseDTO.self, from: data)
            
            return .success(dto.toDomain())
        } catch {
            return .failure(error)
        }
    }
    
}

private extension URL {
    init?(urlString: String) {
        self.init(string: urlString)
    }
}
