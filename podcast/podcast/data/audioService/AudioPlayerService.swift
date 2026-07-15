//
//  AudioPlayerService.swift
//  podcast
//
//  Created by rafi on 13/7/26.
//

import Foundation
internal import Combine

protocol AudioPlayerService: AnyObject {
    var statusPublisher: Published<AudioPlayerStatus>.Publisher { get }
    func play(_ episode: Episode)
    func pause()
    func resume()
}
