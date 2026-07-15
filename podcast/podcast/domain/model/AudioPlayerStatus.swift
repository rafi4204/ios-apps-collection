//
//  AudioPlayerStatus.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

enum AudioPlayerStatus: Equatable {
    case playing(Episode)
    case paused(Episode)
    case idle
    case loading
    case error(String)
}
