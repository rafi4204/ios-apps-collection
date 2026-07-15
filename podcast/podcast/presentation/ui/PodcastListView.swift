//
//  PodcastListView.swift
//  podcast
//
//  Created by rafi on 14/7/26.
//

import SwiftUI

struct PodcastListView: View {
    @StateObject private var viewModel: PodcastSearchViewModel
    @State private var searchQuery = "iOS"
    let container: AppDependencyContainer
    init(container: AppDependencyContainer) {
        self.container = container
            _viewModel = StateObject(wrappedValue: PodcastSearchViewModel(podcastRepository: container.podcastRepository))
        }
    var body: some View {
        // 1. Always wrap your navigation-enabled lists in a NavigationStack
        NavigationStack {
            VStack {
                List(viewModel.podcasts) { podcast in
                    NavigationLink(value: podcast) {
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: podcast.thumbnailURL)) {
                                img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()

                            VStack(alignment: .leading, spacing: 4) {
                                Text(podcast.title)
                                    .font(.headline)
                                Text(podcast.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }  // <-- List ends cleanly here
            }  // <-- VStack ends cleanly here
            // 2. Navigation modifiers attach to the layout containers, OUTSIDE the list loop
            .navigationTitle("Podcast")
            .navigationDestination(for: Podcast.self) { podcast in
                EpisodeListView(container: container, podcast: podcast) // Or your detail view
            }
        }
    }
}

#Preview {
    let container = AppDependencyContainer()
        
    PodcastListView(container: container)
}
