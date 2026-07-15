//
//  EpisodeListViewModel.swift
//  podcast
//
//  Created by rafi on 14/7/26.
//

internal import Combine
import Foundation

@MainActor
class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoading: Bool = false
    @Published var currentPlaybackStatus: AudioPlayerStatus = .idle
    private var podcastRepository: PodcastRepository
    private var audioPlayerService: AudioPlayerService
    private var cancellable = Set<AnyCancellable>()
    init(
        podcastRepository: PodcastRepository,
        auidoPlayerService: AudioPlayerService
    ) {
        self.podcastRepository = podcastRepository
        self.audioPlayerService = auidoPlayerService
        
        observeCurrentPlaybackStatus()
    }

    func fetchEpisodes(for podcast: Podcast) async {
        isLoading = true
        let response = await podcastRepository.fetchEpisodes(
            from: podcast.feedURL
        )
        isLoading = false
        if case .success(let episodes) = response {
            self.episodes = episodes
        }
    }

    func play(episode: Episode) {
        audioPlayerService.play(episode)
    }

    func togglePlayback() {
        switch currentPlaybackStatus {
        case .playing:
            audioPlayerService.pause()
        case .paused:
            audioPlayerService.resume()
        default:
            break
        }
    }

    func observeCurrentPlaybackStatus() {
        audioPlayerService.statusPublisher.receive(on: DispatchQueue.main).sink
        { [weak self] status in
            self?.currentPlaybackStatus = status
        }
        .store(in: &cancellable)
    }

}
