//
//  OpenMeteoResponseDTO.swift
//  weatherapp
//
//  Created by rafi on 12/7/26.
//

struct OpenMeteoResponseDTO: Codable {
    let current: CurrentWeatherDTO

    struct CurrentWeatherDTO: Codable {
        let temperature2m: Double
        let windSpeed10m: Double
        let time: String

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case windSpeed10m = "wind_speed_10m"

        }
    }
}

extension OpenMeteoResponseDTO {
    func toDomain() -> Weather {
        return Weather(
            temperature: current.temperature2m,
            windSpeed: current.windSpeed10m,
            time: current.time
        )
    }
}
