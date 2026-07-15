//
//  PodcastRepository.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

protocol PodcastRepository {
    func searchpodcast(term: String) async -> Result<[Podcast], Error>
    func fetchEpisodes(from feedURL: String) async -> Result<[Episode], Error>
}
