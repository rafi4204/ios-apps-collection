//
//  EpisodeListView.swift
//  podcast
//
//  Created by rafi on 14/7/26.
//

import SwiftUI

struct EpisodeListView: View {
    @StateObject var viewModel: EpisodeListViewModel
    let podcast: Podcast
    let container: AppDependencyContainer
    init(container: AppDependencyContainer, podcast: Podcast) {
        self.podcast = podcast
        self.container = container
        _viewModel = StateObject(
            wrappedValue: EpisodeListViewModel(
                podcastRepository: container.podcastRepository,
                auidoPlayerService: container.audioPlayerService
            )
        )

    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView("Parsing Live Feed...")
                Spacer()
            } else {
                List(viewModel.episodes, id: \.id) { episode in
                    Button(
                        action: {
                            viewModel.play(episode: episode)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(episode.title)
                                .font(.body)
                                .fontWeight(Font.Weight.semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            Text(episode.pubDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                }
            }

            MiniPlayerView(
                status: viewModel.currentPlaybackStatus,
                onTogglePlayback: { viewModel.togglePlayback() }
            )
        }
        .navigationTitle(podcast.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchEpisodes(for: podcast)
        }
    }
}

struct MiniPlayerView: View {
    let status: AudioPlayerStatus
    let onTogglePlayback: () -> Void
    var body: some View {
        switch status {
        case .playing(let episode), .paused(let episode):
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing")
                        .font(.title2)
                    //Spacer()
                    Text(episode.title)
                        .font(.caption)
                }
                Spacer()
                Button(action: onTogglePlayback) {
                    if case .playing = status {
                        Image(systemName: "pause.fill")
                            .font(.title2)
                            .padding()
                    } else {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .padding()
                    }

                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
        case .loading:
            ProgressView("Loading...").padding()

        default:
            EmptyView()
        }
    }
}

#Preview {
    let container = AppDependencyContainer()
    let podcast = Podcast(
        id: 1,
        title: "Test Podcast",
        artist: "A test podcast",
        thumbnailURL: "https://example.com/feed",
        feedURL: "https://example.com/feed"
    )
    EpisodeListView(container: container, podcast: podcast)
}
