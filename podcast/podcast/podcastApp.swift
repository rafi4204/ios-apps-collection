//
//  podcastApp.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

import SwiftUI

@main
struct podcastApp: App {
    
    let container = AppDependencyContainer()
    var body: some Scene {
        WindowGroup {
            PodcastListView(container: container)
        }
    }
}
