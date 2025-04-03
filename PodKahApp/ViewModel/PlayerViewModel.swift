//
//  PlayerViewModel.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import Foundation
import AVFoundation

class PlayerViewModel {
    
    private var currentEpisode: Episode?
    private var podcastPlayer: AVPlayer?
    private var episodes: [Episode] = []
    private var currentIndex: Int = 0
    private var timeObserverToken: Any?
    
    private var playbackProgress: Float = 0.0
    var isPlaying: Bool = false
    var onProgressUpdate: ((Float, Double, Double) -> Void)?
    private var currentTime: Double = 0
    
    func setEpisodes(episodes: [Episode]) {
        self.episodes = episodes
    }
    
    func setCurrentEpisode(episode: Episode) {
        self.currentEpisode = episode
        self.currentIndex = episodes.firstIndex(where: { $0.title == episode.title }) ?? 0
        setupPlayerForEpisode()
    }
    
    func getCurrentEpisode() -> Episode? {
        return currentEpisode
    }
    
    func play() {
        guard let episode = currentEpisode else { return }
        
        if !isPlaying {
            podcastPlayer?.play()
            isPlaying = true
        }
    }
    
    func pause() {
        podcastPlayer?.pause()
        isPlaying = false
    }
    
    func seekTo(progress: Float) {
        let totalDuration = podcastPlayer?.currentItem?.duration.seconds ?? 0
        let targetTime = totalDuration * Double(progress)
        let targetTimeCMTime = CMTime(seconds: targetTime, preferredTimescale: 1)
        
        podcastPlayer?.seek(to: targetTimeCMTime)
    }
    
    func goToPreviousEpisode() {
        reset()
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        let previousEpisode = episodes[currentIndex]
        setCurrentEpisode(episode: previousEpisode)
    }
    
    func goToNextEpisode() {
        reset()
        guard currentIndex < episodes.count - 1 else { return }
        currentIndex += 1
        let nextEpisode = episodes[currentIndex]
        setCurrentEpisode(episode: nextEpisode)
    }
    
    func reset() {
        pause()
        currentTime = 0
        playbackProgress = 0.0
        onProgressUpdate?(playbackProgress, currentTime, podcastPlayer?.currentItem?.duration.seconds ?? 0)
    }
    
    func setupPlayerForEpisode() {
        guard let episode = currentEpisode else { return }
        
        if let currentPlayer = podcastPlayer {
            removePeriodicTimeObserver(from: currentPlayer)
        }
        
        if let audioURL = URL(string: episode.audioURL) {
            podcastPlayer = AVPlayer(url: audioURL)
            addPeriodicTimeObserver()
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func skipForward(seconds: Double = 10) {
        guard let duration = podcastPlayer?.currentItem?.duration.seconds else { return }
        
        let targetTime = min(currentTime + seconds, duration)
        let targetTimeCMTime = CMTime(seconds: targetTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        podcastPlayer?.seek(to: targetTimeCMTime)
    }
    
    func skipBackward(seconds: Double = 10) {
        
        let targetTime = max(currentTime - seconds, 0)
        let targetTimeCMTime = CMTime(seconds: targetTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        podcastPlayer?.seek(to: targetTimeCMTime)
    }
    
    private func addPeriodicTimeObserver() {
        guard let player = podcastPlayer else { return }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = podcastPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            self.currentTime = time.seconds
            let duration = self.podcastPlayer?.currentItem?.duration.seconds ?? 0
            
            if duration > 0 {
                let progress = Float(currentTime / duration)
                self.playbackProgress = progress
                self.onProgressUpdate?(progress, currentTime, duration)
            }
        }
    }
    
    private func removePeriodicTimeObserver(from player: AVPlayer) {
        if let timeObserverToken = timeObserverToken {
            podcastPlayer?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
