//
//  PodcastSearchViewModel.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

internal import Combine
import Foundation

@MainActor
class PodcastSearchViewModel: ObservableObject {
    @Published var podcasts: [Podcast] = []
    let podcastRepository: PodcastRepository

    init(podcastRepository: PodcastRepository? = nil) {
        self.podcastRepository = podcastRepository ?? PodcastRepositoryImpl()
        
    Task {
            await search(query: "swift")
        }
    }

    func search(query: String) async {
        let reponse = await podcastRepository.searchpodcast(term: query)
        switch reponse {
        case .success(let podcasts):
            self.podcasts = podcasts
        case .failure:
            break
        }
    }
}
