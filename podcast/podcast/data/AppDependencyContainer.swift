//
//  AppDependencyContainer.swift
//  podcast
//
//  Created by rafi on 14/7/26.
//

class AppDependencyContainer {
    // Shared singletons across the entire application lifecycle
    let audioPlayerService: AudioPlayerService = BackgroundAudioPlayerService()
    let podcastRepository: PodcastRepository = PodcastRepositoryImpl()
}
