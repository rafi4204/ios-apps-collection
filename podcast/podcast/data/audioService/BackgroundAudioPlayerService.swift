//
//  BackgroundAudioPlayerService.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

import AVFoundation
internal import Combine
import Foundation
import MediaPlayer

class BackgroundAudioPlayerService: ObservableObject, AudioPlayerService {

    @Published var status: AudioPlayerStatus = .idle
    var statusPublisher: Published<AudioPlayerStatus>.Publisher { $status }

    private var avPlayer: AVPlayer?
    private var currentEpisode: Episode?
    // Keeps track of the live player listener so we don't duplicate it
    private var timeObserverToken: Any?

    init() {
        setupAudioSession()
        setupRemoteCommandCenter()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []
            )
            try AVAudioSession.sharedInstance().setActive(true)

        } catch {
            print("Failed to set up audio session")
        }
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.resume()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            guard let self = self else { return .commandFailed }

            if case .playing = self.status {
                self.pause()
            } else {
                self.resume()
            }
            return .success
        }
    }

    private func setupTimeObserver() {
        guard let player = avPlayer else { return }

        // Listen to the playback updates every 1 second
        let interval = CMTime(
            seconds: 1.0,
            preferredTimescale: CMTimeScale(NSEC_PER_SEC)
        )

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] _ in
            guard let self = self, let episode = self.currentEpisode else {
                return
            }

            // Only update the lock screen info if the track is actively playing
            if case .playing = self.status {
                self.updateNowPlayingInfo(for: episode, isPlaying: true)
            }
        }
    }

    private func removeTimeObserver() {
        if let token = timeObserverToken {
            avPlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    func play(_ episode: Episode) {
        guard let url = URL(string: episode.audioURL) else { return }
        // Clean up any old observer before starting a new track
        removeTimeObserver()
        self.currentEpisode = episode
        self.status = .loading
        let playerItem = AVPlayerItem(url: url)
        if self.avPlayer == nil {
            let player = AVPlayer(playerItem: playerItem)
            self.avPlayer = player
        } else {
            avPlayer?.replaceCurrentItem(with: playerItem)
        }

        // Setup the live tracker to capture data once the stream buffers
        setupTimeObserver()

        avPlayer?.play()
        status = .playing(episode)
        updateNowPlayingInfo(for: episode)
    }

    func updateNowPlayingInfo(for episode: Episode, isPlaying: Bool = true) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = "artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "podcast title"
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = false
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] =
            isPlaying ? 1.0 : 0.0
        if let player = avPlayer, let currentItem = player.currentItem {
            // Get total duration from the current playing audio item
            let duration = CMTimeGetSeconds(currentItem.duration)
            // Get the current position of the playhead
            let currentTime = CMTimeGetSeconds(player.currentTime())

            // Feed them into the system dictionary (safely ignoring NaN if the track hasn't loaded yet)
            if !duration.isNaN && !duration.isInfinite && duration > 0 {
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
            }
            if !currentTime.isNaN && !currentTime.isInfinite {
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =
                    currentTime
            }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func pause() {
        avPlayer?.pause()
        if let currentEpisode = currentEpisode {
            updateNowPlayingInfo(for: currentEpisode, isPlaying: false)
            status = .paused(currentEpisode)
        }
    }

    func resume() {
        avPlayer?.play()
        if let currentEpisode = currentEpisode {
            status = .playing(currentEpisode)
            updateNowPlayingInfo(for: currentEpisode, isPlaying: true)
        }
    }

    deinit {
        removeTimeObserver()
        print(
            "🛑 WARNING: BackgroundAudioPlayerService was DESTROYED from memory!"
        )
    }

}
