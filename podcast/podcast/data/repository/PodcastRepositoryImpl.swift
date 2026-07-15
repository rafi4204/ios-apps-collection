//
//  PodcastRepositoryImpl.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

import Foundation

class PodcastRepositoryImpl: PodcastRepository {
    private let session: URLSession = .shared

    func searchpodcast(term: String) async -> Result<[Podcast], Error> {
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(encodedTerm)&media=podcast&limit=20"
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkError.invalidURL)
        }
        do{
            let (data,_) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(iTunesSearchResponse.self, from: data)
            let podcasts = response.results.map{$0.toDomain()}
            return .success(podcasts)
        }catch{
            return .failure(error)
        }
    }

    func fetchEpisodes(from feedURL: String) async -> Result<
        [Episode], Error
    > {
        guard let url = URL(string: feedURL) else{
            return .failure(NetworkError.invalidURL)
        }
        
        do{
            let (data,_) = try await session.data(from: url)
            let parser = PodcastRSSParser()
            let episodes = parser.parse(xmlData: data)
            return .success(episodes)
            
        }catch{
            return .failure(error)
        }
    }
}

struct iTunesSearchResponse: Codable { let results: [iTunesPodcastDTO] }
struct iTunesPodcastDTO: Codable {
    let collectionId: Int
    let collectionName: String
    let artistName: String
    let artworkUrl100: String
    let feedUrl: String?
    
    func toDomain() -> Podcast {
        return Podcast(id: collectionId, title: collectionName, artist: artistName, thumbnailURL: artworkUrl100, feedURL: feedUrl ?? "")
    }
}
