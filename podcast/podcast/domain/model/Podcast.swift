//
//  Podcast.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

struct Podcast: Identifiable, Hashable {
    let id: Int
    let title: String
    let artist: String
    let thumbnailURL: String
    let feedURL: String
}

struct Episode: Identifiable, Hashable {
    var id: String { audioURL }
    let title: String
    let pubDate: String
    let audioURL: String
    let duration: String?
}

